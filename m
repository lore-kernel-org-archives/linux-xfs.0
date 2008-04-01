Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 18:50:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m321o0oJ026399
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 18:50:02 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D07B67268CC
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2008 18:50:33 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id oowllHUU0NRSfBDv for <xfs@oss.sgi.com>; Tue, 01 Apr 2008 18:50:33 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m31L37eL029945
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 14:03:07 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m31L37ec015683
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 14:03:07 -0700
Message-ID: <47F2A321.60907@agami.com>
Date: Tue, 01 Apr 2008 14:03:29 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Re: Definition of XFS_DQUOT_LOGRES()
References: <47F16988.2080406@agami.com> <20080401012856.GL103491721@sgi.com>
In-Reply-To: <20080401012856.GL103491721@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

David Chinner wrote:
> On Mon, Mar 31, 2008 at 03:45:28PM -0700, Michael Nishimoto wrote:
>> The comment for XFS_DQUOT_LOGRES states that we need to reserve space
>> for 3 dquots.  I can't figure out why we need to add this amount to *all*
>> operations and why this amount wasn't added after doing a runtime
>> quotaon check.
> 
> It probably could be done that way.  But given that:
> 
>> /*
>>  * In the worst case, when both user and group quotas are on,
>>  * we can have a max of three dquots changing in a single transaction.
>>  */
>> #define XFS_DQUOT_LOGRES(mp)    (sizeof(xfs_disk_dquot_t) * 3)
> 
> sizeof(xfs_disk_dquot_t) = 104 bytes,
> 
> the overall addition to the reservations is minor considering:
> 
> [0]kdb> xtrres 0xe0000038055ac6c0
> write: 109752   truncate: 223672        rename: 305976
> link: 153144    remove: 153144  symlink: 158520
> create: 158392  mkdir: 158392   ifree: 58936
> ichange: 2104   growdata: 45696 swrite: 384
> addafork: 70584 writeid: 384    attrinval: 179328
> attrset: 22968  attrrm: 90552   clearagi: 1152
> growrtalloc: 66048      growrtzero: 4224        growrtfree: 6272
> [0]kdb>
> 
> on a 14GB filesystem most of the transactions this is added to
> are on the far side of 150k and that means we're talking about less
> than 0.2% of the entire reservation comes from the dquot. With
> larger block sizes and/or larger filesystems, these get much
> larger. e.g. same 14GB device, 64k block size instead of 4k:
> 
> [0]kdb> xtrres 0xe00000b8027d39f8
> write: 987576   truncate: 1977272       rename: 2891064
> link: 1445688   remove: 1445688 symlink: 1512504
> create: 1511864 mkdir: 1511864  ifree: 470584
> ichange: 1592   growdata: 395904        swrite: 384
> addafork: 658616        writeid: 384    attrinval: 1581696
> attrset: 329656 attrrm: 791480  clearagi: 640
> growrtalloc: 592640     growrtzero: 65664       growrtfree: 67200
> 
> The rename reservation is *2.8MB* (up from 300k). IOWs, 300 bytes is
> really noise when it comes to reservation space. (OT: See why I want to
> increase the log size now? :)
> 
> Is it worth the complexity of adding this dquot reservation at
> runtime for a best case reduction of 0.2% in log space reservation
> usage? Probably not, but patches can be convincing ;)
> 
> Cheers,
> 
> Dave.

Here is a patch to fix a sign problem when growing the log to 2G.


--- xfs_log.2.c 2008-04-01 11:55:45.000000000 -0700
+++ xfs_log.3.c 2008-04-01 11:56:53.000000000 -0700
@@ -230,20 +230,24 @@
  static void
  xlog_grant_add_space_write(struct log *log, int bytes)
  {
-       log->l_grant_write_bytes += bytes;
-       if (log->l_grant_write_bytes > log->l_logsize) {
-               log->l_grant_write_bytes -= log->l_logsize;
-               log->l_grant_write_cycle++;
+       int __tmp = (log)->l_logsize - (log)->l_grant_write_bytes;
+       if (__tmp > bytes)
+               (log)->l_grant_write_bytes += bytes;
+       else {
+               (log)->l_grant_write_cycle++;
+               (log)->l_grant_write_bytes = bytes - __tmp;
         }
  }

  static void
  xlog_grant_add_space_reserve(struct log *log, int bytes)
  {
-       log->l_grant_reserve_bytes += bytes;
-       if (log->l_grant_reserve_bytes > log->l_logsize) {
-               log->l_grant_reserve_bytes -= log->l_logsize;
-               log->l_grant_reserve_cycle++;
+       int __tmp = (log)->l_logsize - (log)->l_grant_reserve_bytes;
+       if (__tmp > bytes)
+               (log)->l_grant_reserve_bytes += bytes;
+       else {
+               (log)->l_grant_reserve_cycle++;
+               (log)->l_grant_reserve_bytes = bytes - __tmp;
         }
  }
