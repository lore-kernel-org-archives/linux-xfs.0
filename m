Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34098 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbcIICjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 22:39:14 -0400
Received: by mail-oi0-f44.google.com with SMTP id m11so110000403oif.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Sep 2016 19:39:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160909023153.GN2356@ZenIV.linux.org.uk>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard> <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk> <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard> <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard> <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <20160909023153.GN2356@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Sep 2016 19:39:12 -0700
Message-ID: <CA+55aFz0qYrVFqz_TLs0U9Us5fhB89CUV+x_Gje-oL9BaYT2rg@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 8, 2016 at 7:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> We care because __generic_file_splice_read() is playing fast and loose with
> pagecache.  It gathers pointers to pages and *then* issues ->readpage() on
> them.  Without any protection against hole-punching.

Ugh. It should just lock them when it gathers the pointers.

And in fact they *are* locked for the add_to_page_cache_lru() case,
but the splice code explicitly unlocks them in order to then
unconditionally lock them *again* in the IO path.

Oh, that's just crazy. And stupid.

You're right, that code just has to be killed. It's too wrong to live.

If you can replace it with the generic read iterator, then that does
indeed just fix things. So color me convinced.

              Linus
