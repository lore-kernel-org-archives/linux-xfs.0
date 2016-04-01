Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 002007CC9
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 12:24:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA06B304039
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 10:24:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id b4DQaYz7WDQBAAel for <xfs@oss.sgi.com>;
	Fri, 01 Apr 2016 10:24:41 -0700 (PDT)
Subject: Re: [PATCH] xfs/133 134 262: limit xfs_quota report to report on
	specific project quota id
References: <1459494050-28330-1-git-send-email-eguan@redhat.com>
	<20160401072856.GA3329@dhcp12-237.nay.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56FEAED8.2050108@sandeen.net>
Date: Fri, 1 Apr 2016 12:24:40 -0500
MIME-Version: 1.0
In-Reply-To: <20160401072856.GA3329@dhcp12-237.nay.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zorro Lang <zlang@redhat.com>, Eryu Guan <eguan@redhat.com>
Cc: sandeen@redhat.com, fstests@vger.kernel.org, xfs@oss.sgi.com



On 4/1/16 2:28 AM, Zorro Lang wrote:
> On Fri, Apr 01, 2016 at 03:00:50PM +0800, Eryu Guan wrote:
>> With GETNEXTQUOTA support, xfs_quota -c "report" now outputs more quota
>> info than before, and this breaks xfs/133 xfs/134 and xfs/262, e.g.
>> xfs/133 fails as
>>
>>      Filesystem Blocks Quota Limit Warn/Time Mounted on
>>      SCRATCH_DEV 0 102400 204800 00 [--------] SCRATCH_MNT
>>      === report command output ===
>>     +(null) 0 0 0 00 [--------]
>>      123456-project 0 102400 204800 00 [--------]
>>
>> Fix it by limiting xfs_quota to report on specific project quota number
>> using -L & -U option, so only the project quota being tested is
>> reported.
>>
>> Signed-off-by: Eryu Guan <eguan@redhat.com>
>> ---
>>
>> I'm not sure if kernel should be fixed, but limiting the quota report on
>> project number being tested seems something worth doing to me anyway. It avoids
>> breakage of future changes of quota report output.
> 
> Hi,
> 
> FYI:
> About "+(null) 0 0 0 00 [--------]"problem, it has been talked in:
> http://thread.gmane.org/gmane.comp.file-systems.fstests/1852/focus=1968
> 
> I think:
> 1) If we consider that this's a bug, the original test cases can
> be the reproducer of this bug, so we shouldn't change the cases.
> 
> 2) If we think print "(null) 0 0 0 00 [--------]" is right(or not
> wrong), then this patch is good.

yes, I'm sorry I didn't take care of this sooner.

I don't think there's value in printing the "(null)" line; I think maybe my
suggestion from that old thread might be best:

> We could explicitly look up id 0 and not show it if it's not in the
> projects file.

Or now that I think about it - projid 0 is the default project quota, right?

Assuming that's correct, perhaps we should conditionally print the line,
changing "(null)" to "default", printing it only if a default quota is 
set (i.e. not all zeros).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
