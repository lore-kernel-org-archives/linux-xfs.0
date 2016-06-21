Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F9E27CA1
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 08:54:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0199C304032
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 06:54:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YwFLXFijV1C11yzb for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2016 06:54:05 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6BFA215B13
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 08:54:05 -0500 (CDT)
Subject: Re: [PATCH 2/2] xfs_check: process sparse inode chunks correctly
References: <1466441562-12317-1-git-send-email-bfoster@redhat.com>
	<1466441562-12317-3-git-send-email-bfoster@redhat.com>
	<20160621090153.GB28212@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <de32a39e-864d-bd4d-8d5d-7a019b8e445f@sandeen.net>
Date: Tue, 21 Jun 2016 08:54:04 -0500
MIME-Version: 1.0
In-Reply-To: <20160621090153.GB28212@redhat.com>
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
To: xfs@oss.sgi.com



On 6/21/16 4:01 AM, Carlos Maiolino wrote:
> On Mon, Jun 20, 2016 at 12:52:42PM -0400, Brian Foster wrote:
>> Update the inode btree scanning functions to process sparse inode chunks
>> correctly. For filesystems with sparse inode support enabled, process
>> each chunk a cluster at a time. Each cluster is checked against the
>> inobt record to determine if it is a hole and skipped if so.
>>
>> Note that since xfs_check is deprecated in favor of xfs_repair,  this
>> adds the minimum support necessary to process sparse inode enabled
>> filesystems. In other words, this adds no sparse inode specific checks
>> or verifications. We only update the inobt scanning functions to extend
>> the existing level of verification to sparse inode enabled filesystems
>> (e.g., avoid incorrectly tracking sparse regions as inodes). Problems
>> or corruptions associated with sparse inode records must be detected and
>> recovered via xfs_repair.
>>
> 
> Hi,
> 
> I'm not quite sure, but a while ago, I thought I've heard some rumors about
> deprecating xfs_check, is this true or something that my mind made up for some
> weird reason?

Yes, like Brian said above.  ;)

bfc541e xfsprogs: remove xfs_check
12a48f5 xfsprogs: remove xfs_check references from fsck.xfs script & manpage

However, we still run check inside xfs_db in xfstests as an independent
verification step:

187bccd xfstests: Remove dependence of xfs_check script

+# xfs_check script is planned to be deprecated. But, we want to
+# be able to invoke "xfs_check" behavior in xfstests in order to
+# maintain the current verification levels.
+_xfs_check()

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
