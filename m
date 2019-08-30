Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BA1C3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF8732186A
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:28:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="4Yo5Fm4C";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="c382ua9V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfH3L2A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 07:28:00 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:58459 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727326AbfH3L2A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 07:28:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 386C9530;
        Fri, 30 Aug 2019 07:27:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 30 Aug 2019 07:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        ka5Mh14WgL6VEZzfCDLpdf8A0rLY/eBSvw4ErxJjp0s=; b=4Yo5Fm4CxZHq6CX9
        q/bYn9ifJq4adgCjKoaK0jWRypmOyZyjTx4X67IwC0x3ywWZ6hzS7y4cyu2NrwH+
        u+a5TqBw93Uwxut8Mebfn254XFyGiNGP1TKkPWxLRI+HLTi+xlG070crc8arzchj
        JS5VTL7cvWBVEiuauWc9L8WNNXQRByijHEtdPwtqRvJ6DfTFVjOLhm+7/93jaBoY
        6V0Ix30LMV5beF/OWIDGwHmKjiS4PSne4fLWqUiwG70wEL+msd3ckk0asHuQEcA/
        popFYEJpLfQGTGXpmr2AtrEoRD4OIcqF1TqdT8xuoM5vvVsZfn0c5hI+1kVTIQG3
        YRGpiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=ka5Mh14WgL6VEZzfCDLpdf8A0rLY/eBSvw4ErxJjp
        0s=; b=c382ua9VTnsBKdOhGb79P7Vbc3SNFA+1JbLvvdcQLiBhnS5QoyCiAp7MO
        N/JACABN2MdCwT9a3KeBcEZ1Ir6AC7LmtED4WYliSOC076HhDakByL/9wxWj9BCR
        XgNvtquh5r+vrUlKlV9BObYh22Cdj2IlaNVkZS8jY+qy/865AcPwXSMideKXPby/
        PZjlP9rZMIdVZG0ECdgE7dTw9Ooh4SthBs4Vyz9L4eduhp5aoj1I5U/+lN4SKhBw
        cGLRJskMJSwv967R10G+bsmUioKu3IS1P9y2GAgK2YXidGT7Cpg2Qg9UmUpbnhHt
        UfilwxScDkzfhVrWfWMG4qRk44LSA==
X-ME-Sender: <xms:PghpXbaWHGCbY12psepszUiwupOS3ikVOAWWC4UIgkBdICwPbhRZrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthekredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:PghpXUcPqbFihp0QWgA55ntM6i55nd-RM_wsbgk-H2TZ3nWdGv4QcA>
    <xmx:PghpXd2mA6Q7tVRTFiUBi5nu-a5TaFgJBus_4sB6S1b-jHKj-EEcJQ>
    <xmx:PghpXTKVnSWFtDh2VR_LzjrHiYACaSvk2KYCxIn5vKSn1ZcVFexILw>
    <xmx:PghpXZZdHn8w48ylwiCXQxjWhZ-pQx2H1Tc04O-DU3Le_eaxfdwnIQ>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9BC4F80069;
        Fri, 30 Aug 2019 07:27:55 -0400 (EDT)
Message-ID: <3b41fe58a4d7d74008d008dae95de47b013c0cb5.camel@themaw.net>
Subject: Re: [PATCH v2 14/15] xfs: mount-api - switch to new mount-api
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 30 Aug 2019 19:27:52 +0800
In-Reply-To: <20190828132914.GG16389@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652203256.2607.18022916035406730007.stgit@fedora-28>
         <20190828132914.GG16389@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-08-28 at 09:29 -0400, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 09:00:32AM +0800, Ian Kent wrote:
> > The infrastructure needed to use the new mount api is now
> > in place, switch over to use it.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |   51
> > +++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 49 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index d2a1a62a3edc..fe7acd8ddd48 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -2123,7 +2123,6 @@ static const struct super_operations
> > xfs_super_operations = {
> >  	.freeze_fs		= xfs_fs_freeze,
> >  	.unfreeze_fs		= xfs_fs_unfreeze,
> >  	.statfs			= xfs_fs_statfs,
> > -	.remount_fs		= xfs_fs_remount,
> 
> Not clear why this needs to go away here, or at least why we don't
> remove the function at the same time.
> 
> Indeed.. this patch actually throws a couple warnings:
> 
> ...
>   CC [M]  fs/xfs/xfs_super.o
> fs/xfs/xfs_super.c:2088:1: warning: ‘xfs_fs_mount’ defined but not
> used [-Wunused-function]
>  xfs_fs_mount(
>  ^~~~~~~~~~~~
> fs/xfs/xfs_super.c:1448:1: warning: ‘xfs_fs_remount’ defined but not
> used [-Wunused-function]
>  xfs_fs_remount(
>  ^~~~~~~~~~~~~~
> ...

Yes I saw those too and I was very tempted to remove those
functions at the time.

But I decided the warning was preferable to obsuring what
the change was really doing.

I think now you find this a problem I'll just remove the
functions.

IIRC .remount_fs is removed so it won't be called.

But to be honest I'm not certain that needs to be done.

In any case it really should go away when changing to
use the mount api so I think it needs to be done.

> 
> >  	.show_options		= xfs_fs_show_options,
> >  	.nr_cached_objects	= xfs_fs_nr_cached_objects,
> >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> > @@ -2157,10 +2156,58 @@ static const struct fs_context_operations
> > xfs_context_ops = {
> ...
> >  static struct file_system_type xfs_fs_type = {
> >  	.owner			= THIS_MODULE,
> >  	.name			= "xfs",
> > -	.mount			= xfs_fs_mount,
> > +	.init_fs_context	= xfs_init_fs_context,
> > +	.parameters		= &xfs_fs_parameters,
> 
> Just a random observation.. we have a .name == "xfs" field here and
> the
> parameters struct has a .name == "XFS" field. Perhaps we should be
> consistent?

Yeah, others are seeing similar inconsistencies.

Not sure what I'll do about these yet but it is a problem I think
so I'll need to come up with something sensible.

> 
> Brian
> 
> >  	.kill_sb		= kill_block_super,
> >  	.fs_flags		= FS_REQUIRES_DEV,
> >  };
> > 

