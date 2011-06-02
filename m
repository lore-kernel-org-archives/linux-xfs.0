Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p52HMvjY212325 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 12:22:57 -0500
Received: from idcmail-mo2no.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D4B3165845F
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 10:22:54 -0700 (PDT)
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9]) by
	cuda.sgi.com with ESMTP id v68ynxYl8grEVN2U for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2011 10:22:54 -0700 (PDT)
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Mime-Version: 1.0 (Apple Message framework v1082)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <4DE7A557.9040608@redhat.com>
Date: Thu, 2 Jun 2011 11:22:53 -0600
Message-Id: <7D3F86FA-5AA9-49B0-9AFE-F597E83C07B4@dilger.ca>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>	<20110601232804.GL32466@dastard>	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
	<4DE7A557.9040608@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Amir Goldstein <amir73il@users.sf.net>, xfs@oss.sgi.com, sergey57@gmail.com, "Amir G." <amir73il@users.sourceforge.net>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On 2011-06-02, at 8:59 AM, Eric Sandeen wrote:
> On 6/2/11 2:16 AM, Amir G. wrote:
>> OK, after upgrading to newer util-linux and building it from git,
>> which also didn't help, I finally found who to blame - me.
>> I had an old (noauto) entry in /etc/fstab which claimed that /dev/sda5 is ext4.
>> fsck was picking up that entry and insisting that /dev/sda5 is ext4
>> (regardless of what it really is)
>> blkid isn't doing that silly thing.
> 
> So where are we at with all this?
> 
> I don't really mind adding ext4dev to FSTYP case statements, it -is- something which blkid could, in theory, still return, and making xfstests cope with that and try to invoke fsck -t ext4dev doesn't bother me too much.  It is sadly an fs type embedded into a few tools.

I'm perfectly OK with using ext4dev as a filesystem type that allows testing
changes to ext4 on a system that is already running ext4 as the root fs.

> But other than that, I don't think we should be making changes to upstream projects based on your current development hacks (I don't mean hack in a bad way, just that running sed across ext4 to create your custom filesystem for testing should not require upstream projects to change...)

No, but it's not like this is affecting a lot of tools, just one that is
used by filesystem developers.

> So I'm ok with sprinkling "ext4|ext4dev" around if necessary.  Anyone else disagree?

The other alternative is to change all of the "ext2|ext3|ext4|ext4dev" case
statements to be "ext[2-9]*", or "ext[3-9]*", or "ext[4-9]*" for checks that
are only valid for newer codes and be done with it.  It's a lot easier to
read, and we don't have to change it again should we ever get ext5 or whatever
(hopefully btrfs will be ready before that, but who knows).

Cheers, Andreas





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
