Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5978D7CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 18:09:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 465968F8033
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 16:09:33 -0700 (PDT)
Received: from mail-pd0-f172.google.com (mail-pd0-f172.google.com
	[209.85.192.172]) by cuda.sgi.com with ESMTP id
	NvdxXlvT37Raai68 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Apr 2013 16:09:32 -0700 (PDT)
Received: by mail-pd0-f172.google.com with SMTP id 4so2692180pdd.17
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 16:09:31 -0700 (PDT)
Subject: Re: [PATCH] [PATCH] xfstests: use -F when making scratch ext4 fs
Mime-Version: 1.0 (Apple Message framework v1085)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <517AD302.4000905@redhat.com>
Date: Fri, 26 Apr 2013 17:09:28 -0600
Message-Id: <E173CD13-2FD1-45A4-BEAE-815A9DEC4B62@dilger.ca>
References: <1367003813-17686-1-git-send-email-jbacik@fusionio.com>
	<517AD302.4000905@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-ext4@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On 2013-04-26, at 1:18 PM, Eric Sandeen wrote:
> On 4/26/13 2:16 PM, Josef Bacik wrote:
>> mkfs.ext4 will ask you if you are sure if you try to mkfs an entire disk instead of just a partition, so any xfstest that uses a scratch device and you specify a full disk will appear to hang because it's waiting for you to say yes.  This fixes the problem by just forcing it to do its thing.  Thanks,
>> 
>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> The whole-disk test is pretty derpy anyway. Too bad -F overrides
> much more than just that, but this is probably a decent
> thing to do.

Yeah, we've had to work around the whole-device check for years,
because the 512-byte sector offset for the DOS partition table
kills performance on RAID systems.

Given that the kernel should hold the whole block device busy these
days for O_EXCL opens if there are partitions on the device, it
should be safe to remove this check from mke2fs, though the above
workaround would still be needed for a while.

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
