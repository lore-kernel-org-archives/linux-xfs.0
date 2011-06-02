Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p52ExhVg207219 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 09:59:43 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C69B497847
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 07:59:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Cwh5zeQII5auWMHa for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2011 07:59:42 -0700 (PDT)
Message-ID: <4DE7A557.9040608@redhat.com>
Date: Thu, 02 Jun 2011 09:59:35 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>	<20110601232804.GL32466@dastard>	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
In-Reply-To: <BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Amir G." <amir73il@users.sourceforge.net>
Cc: Amir Goldstein <amir73il@users.sf.net>, xfs@oss.sgi.com, sergey57@gmail.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On 6/2/11 2:16 AM, Amir G. wrote:

> OK, after upgrading to newer util-linux and building it from git,
> which also didn't help, I finally found who to blame - me.
> I had an old (noauto) entry in /etc/fstab which claimed that /dev/sda5 is ext4.
> fsck was picking up that entry and insisting that /dev/sda5 is ext4
> (regardless of what it really is)
> blkid isn't doing that silly thing.
> 
> Amir

So where are we at with all this?

I don't really mind adding ext4dev to FSTYP case statements, it -is- something which blkid could, in theory, still return, and making xfstests cope with that and try to invoke fsck -t ext4dev doesn't bother me too much.  It is sadly an fs type embedded into a few tools.

But other than that, I don't think we should be making changes to upstream projects based on your current development hacks (I don't mean hack in a bad way, just that running sed across ext4 to create your custom filesystem for testing should not require upstream projects to change...)

So I'm ok with sprinkling "ext4|ext4dev" around if necessary.  Anyone else disagree?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
