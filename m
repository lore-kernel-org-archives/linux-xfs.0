Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2846CCA9EC0
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 00:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB17D218AC
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 00:52:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AFcyw/YY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfJ2AwV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 20:52:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55808 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJ2AwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 20:52:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T0mlYJ041114;
        Tue, 29 Oct 2019 00:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=fjpM/4YNzZK5H2egVvhQMb7GNua6cs9BPE1Qly296uA=;
 b=AFcyw/YYQ2pYxPFJBUC2CDYi0p1XZX8E7JyQKaUNQ+ykfxAouH0khBxT8/MuhXBxRPRp
 NdI0g55u+44EYNg/iUYr42UVGp38HGw2HKj8FuJznVb50hAACwbmaUGym2zWIeCP3IB3
 N4x9sdnUVNzMTSYT/mWa+4dtzmwbHhtQAS9smpBtQIJdL03/xOi9RH3CzmNXRjEx/40W
 Rf5983rIWWHREDAXRyuBwd+8Dk1ih7k2lyV2uTWdoS6UANAG3VxaVtr3Eqqye/pCE32c
 I4DeLNzXnqdsL58kTVnU6Tu02uq6P5Bso6DO2HW688GTN1U0XkE/zEI5gsYVk25/333N Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vvumfa9dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 00:52:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T0mjVf102394;
        Tue, 29 Oct 2019 00:52:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vvykswjr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 00:52:11 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9T0qAA1023435;
        Tue, 29 Oct 2019 00:52:10 GMT
Received: from localhost (/10.159.156.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 17:52:09 -0700
Date:   Mon, 28 Oct 2019 17:52:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: About xfstests generic/361
Message-ID: <20191029005208.GD15221@magnolia>
References: <1d94634d5c990dc0d21673ff2596bd276b728ab1.camel@themaw.net>
 <20191028233448.GB15221@magnolia>
 <b6a64fa89ab24912b840c0772c2ffa615c0c6118.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a64fa89ab24912b840c0772c2ffa615c0c6118.camel@themaw.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1031
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 08:29:38AM +0800, Ian Kent wrote:
> On Mon, 2019-10-28 at 16:34 -0700, Darrick J. Wong wrote:
> > On Mon, Oct 28, 2019 at 05:17:05PM +0800, Ian Kent wrote:
> > > Hi Darrick,
> > > 
> > > Unfortunately I'm having a bit of trouble with my USB keyboard
> > > and random key repeats, I lost several important messages this
> > > morning due to it.
> > > 
> > > Your report of the xfstests generic/361 problem was one of them
> > > (as was Christoph's mail about the mount code location, I'll post
> > > on that a bit later). So I'm going to have to refer to the posts
> > > and hope that I can supply enough context to avoid confusion.
> > > 
> > > Sorry about this.
> > > 
> > > Anyway, you posted:
> > > 
> > > "Dunno what's up with this particular patch, but I see regressions
> > > on
> > > generic/361 (and similar asserts on a few others).  The patches
> > > leading
> > > up to this patch do not generate this error."
> > > 
> > > I've reverted back to a point more or less before moving the mount
> > > and super block handling code around and tried to reproduce the
> > > problem
> > > on my test VM and I din't see the problem.
> > > 
> > > Is there anything I need to do when running the test, other have
> > > SCRATCH_MNT and SCRATCH_DEV defined in the local config, and the
> > > mount point, and the device existing?
> > 
> > Um... here's the kernel branch that I used:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=mount-api-crash
> 
> Ok, I'll see what I can do with that.
> 
> > 
> > Along with:
> > 
> > MKFS_OPTIONS -- -m crc=0
> 
> Right.
> 
> > MOUNT_OPTIONS -- -o usrquota,grpquota
> 
> It looked like generic/361 used only the SCRATCH_DEV so I thought
> that meant making a file system and mounting it within the test.

Yes.  MOUNT_OPTIONS are used to mount the scratch device (and in my case
the test device too).

> > and both TEST_DEV and SCRATCH_DEV pointed at boring scsi disks.
> 
> My VM disks are VirtIO (file based) virtual disks, so that sounds
> a bit different.
> 
> Unfortunately I can't use raw disks on the NAS I use for VMs and
> I've migrated away from having a desktop machine with a couple of
> disks to help with testing.
> 
> I have other options if I really need to but it's a little bit
> harder to setup and use company lab machines remotely, compared to
> local hardware (requesting additional disks is hard to do), and
> I'm not sure (probably not) if they can/will use raw disks (or
> partitions) either.

Sorry, I meant 'boring SCSI disks' in a VM.

Er let's see what the libvirt config is...

    <disk type='file' device='disk'>
      <driver name='qemu' type='raw' cache='unsafe' discard='unmap'/>
      <source file='/run/mtrdisk/a.img'/>
      <target dev='sda' bus='scsi'/>
      <address type='drive' controller='0' bus='0' target='0' unit='0'/>
    </disk>

Which currently translates to virtio-scsi disks.

> > 
> > > This could have been a problem with the series I posted because
> > > I did have some difficulty resolving some conflicts along the
> > > way and may have made mistakes, hence reverting to earlier patches
> > > (but also keeping the recent small pre-patch changes).
> > 
> > Yeah, I had the same problem too; you might spot check the commits in
> > there just in case /I/ screwed them up.
> 
> I will, yes.
> 
> > 
> > (I would say 'or rebase on for-next' but (a) I don't know how
> > Christoph's mount cleanups intermix with that and (b) let's see if
> > this afternoon's for-next is less broken on s390 than this morning's
> > was
> > <frown>)
> 
> I neglected to mention that my series is now based on the for-next
> branch as I noticed the get_tree_bdev() fix is present so I can drop
> the first patch.
> 
> It seemed to me that the for-next branch is the right place to base
> the series. I expect there will be the odd bump in the road of course
> ...

Heh. Yes. :)

--D

> Ian
> 
