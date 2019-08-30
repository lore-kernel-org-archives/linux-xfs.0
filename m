Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB34C3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3185321670
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="l2cyI0fP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dbKQKyOF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfH3KXz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:23:55 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:50369 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727521AbfH3KXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 06:23:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 452C1501;
        Fri, 30 Aug 2019 06:23:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 30 Aug 2019 06:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        14xVU3ZGdtNzYe7qePuaXaUlKE7VzHh818t77C/A9Cc=; b=l2cyI0fPOIZI1pez
        8ha2aX+4Qct29FxwS5sf7mtbIFISmyVedL/ou6DUdnaQQHkmhw7Q/iPHS1JEw9n1
        Hk8aLNJmsSAbZEAcY8iVRMsL6xAwQ+9fnArBH/Ehkfa7Ng+RdQCXZYr1VLlDayPh
        sF0dmYnoWP9ZU5vDKAMdtVd5RY1oqYFSno2t03nxSE0GH1IAWe4f5TIMAFjg/1Vg
        C9yHh+kNwWdRwoUVNda17ntEbUVR0GT4iBQ4ydLdIe1J3bxDjYqfQ614gfS1uWHS
        XeQ8bNRFFe7YpBkv13oW4AUh3RgG0Pnya0rciHVoO2i4A1CPFvMjv/6E97XDSNBR
        BEjC6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=14xVU3ZGdtNzYe7qePuaXaUlKE7VzHh818t77C/A9
        Cc=; b=dbKQKyOFfCVConN53WcYhsyHO0EumIC/uMVemQBh7ESzt9dwNqU2RFLug
        MWCsVROfALeYoRvFcEqMCIUO9dyt/bEoQ8rg+a1b3r1bsjW4AUm65o5sQr7EW+cr
        nmE3nrGon/Yd2va6EQcyiJMgmN1RQz7AWAAyLhUmjKXH99H8AzxMSz+azZg9vEwA
        LgCUaYzblMr4W60Rib8Psed6N9S7SFC3np9KwbO08jvqghcxivuEajQWNI3p/3Tz
        zjp0GQvI/tzLCTX4gGfRknF3FR3sxnn/7nyPjLyUGoPYbyz5v2LTTjdAZvJo1hdH
        f+JNm+O2lOnymAMuRoFqNbUuREFRA==
X-ME-Sender: <xms:OfloXR7ljl6eITo68HYKi4vxXvEkLxR_ipDC1rX0fVKSPGwmnYbYoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:OfloXYgFpFycX6yJhBHj1EA5j6b89qiGfK1S_bdLncVPfdtKwBM7CQ>
    <xmx:OfloXb7ykwSJGqoZVrljNbMdeyPrReBQfPHUf0Duo2U15XlhU7t30g>
    <xmx:OfloXRDvRNg8SjEllPZ2JhoqklM8VBNcJEKD9Xh1sO8K33VS90Hpqg>
    <xmx:OfloXbcB0WtBHVBnMbB4Oo8Jb3hmlFkFX42u2DdLBjwpMRbJw0swlw>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id C19728005B;
        Fri, 30 Aug 2019 06:23:50 -0400 (EDT)
Message-ID: <318f751400bd90a52bb3c41ab4debbf4c9771f7f.camel@themaw.net>
Subject: Re: [PATCH v2 05/15] xfs: mount-api - make xfs_parse_param() take
 context .parse_param() args
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 30 Aug 2019 18:23:46 +0800
In-Reply-To: <a6c39432-063e-a619-1691-83134f8fafef@sandeen.net>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652198391.2607.14772471190581142304.stgit@fedora-28>
         <4fcd7f09-88d9-35c7-d6f3-2c6407260fee@sandeen.net>
         <a6c39432-063e-a619-1691-83134f8fafef@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-08-26 at 14:31 -0500, Eric Sandeen wrote:

Finally got time to start looking at this.

> On 8/26/19 2:19 PM, Eric Sandeen wrote:
> > >  	case Opt_biosize:
> > > -		if (match_kstrtoint(args, 10, &iosize))
> > > +		if (suffix_kstrtoint(param->string, 10, &iosize))
> > >  			return -EINVAL;
> > > -		*iosizelog = ffs(iosize) - 1;
> > > +		ctx->iosizelog = ffs(iosize) - 1;
> > >  		break;
> > >  	case Opt_grpid:
> > > +		if (result.negated)
> > > +			mp->m_flags &= ~XFS_MOUNT_GRPID;
> > > +		else
> > > +			mp->m_flags |= XFS_MOUNT_GRPID;
> > > +		break;
> > Is there any real advantage to this "fsparam_flag_no" / negated
> > stuff?
> > I don't see any other filesystem using it (yet) and I'm not totally
> > convinced
> > that this is any better, more readable, or more efficient than just
> > keeping
> > the "Opt_nogrpid" stuff around.  Not a dealbreaker but just
> > thinking out
> > loud... seems like this interface was a solution in search of a
> > problem?
> 
> Also, at least as of this patch, it seems broken:
> 
> [xfstests-dev]# mount -o noikeep /dev/pmem0p1 /mnt/test
> mount: mount /dev/pmem0p1 on /mnt/test failed: Unknown error 519
> 
> <dmesg shows nothing>
> 
> [xfstests-dev]# mount -o ikeep /dev/pmem0p1 /mnt/test
> mount: wrong fs type, bad option, bad superblock on /dev/pmem0p1,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> [xfstests-dev]# dmesg | tail -n 1
> [  282.281557] XFS: Unexpected value for 'ikeep'

Bizare, everything I'm looking at says this case shouldn't trigger!
Think I'm going to need to burn some grey cells on this, ;)

Ian

