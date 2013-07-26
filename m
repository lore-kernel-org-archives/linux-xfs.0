Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 96A4B29E1D
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 11:15:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 85FF78F8035
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 09:15:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SnCW35ICp2DapsUf for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 09:15:15 -0700 (PDT)
Message-ID: <51F2A091.3010407@sandeen.net>
Date: Fri, 26 Jul 2013 11:15:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: exit out if _scratch_mount fails
References: <1373396847-7975-1-git-send-email-jbacik@fusionio.com>
	<20130726161235.GK3111@sgi.com>
In-Reply-To: <20130726161235.GK3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linxu-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On 7/26/13 11:12 AM, Ben Myers wrote:
> Hey Josef,
> 
> On Tue, Jul 09, 2013 at 03:07:27PM -0400, Josef Bacik wrote:
>> I test some of the different mkfs options for btrfs, one set doesn't work
>> properly with small file systems, so the fs won't mount.  This is fine from a
>> btrfs point of view, but tests that fail to mount the scratch fs will run
>> anyway, so if it's a "fill the fs" sort of test this will wreak havoc.  To fix
>> this just error out of _scratch_mount fails.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> I noticed that this change causes dmapi tests to try to be run on systems that
> don't have dmapi supported, and they fail.  Have you seen this?
> 
> Thanks,
> 	Ben

I haven't tested either way, but does:

     _mount -t $FSTYP `_scratch_mount_options $*` || _fail "Scratch mount failed"

work any better?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
