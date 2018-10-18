Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f45.google.com ([209.85.128.45]:40714 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbeJRToT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 15:44:19 -0400
Received: by mail-wm1-f45.google.com with SMTP id z204-v6so5440943wmc.5
        for <linux-xfs@vger.kernel.org>; Thu, 18 Oct 2018 04:43:40 -0700 (PDT)
Date: Thu, 18 Oct 2018 13:43:35 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [QUESTION] multiple fsync() vs single sync()
Message-ID: <20181018114335.vc7cdqpgcv34mnez@odin.usersys.redhat.com>
References: <6A65F394-C1BA-4339-AC9B-051885D12F65@corp.ovh.com>
 <20181016125712.5k5xt4lzhi76qaj6@odin.usersys.redhat.com>
 <CAAxjCEyUL4nJ_Ds+ATragxGtUCyHjkZ9howsMHjc5H7VEe3xUg@mail.gmail.com>
 <2C57B701-747D-4603-9DA7-F4D766858C36@corp.ovh.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2C57B701-747D-4603-9DA7-F4D766858C36@corp.ovh.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Romain Le Disez <romain.le-disez@corp.ovh.com>
Cc: Stefan Ring <stefanrin@gmail.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Tue, Oct 16, 2018 at 02:09:27PM +0000, Romain Le Disez wrote:
> 
> > Le 16 oct. 2018 à 15:53, Stefan Ring <stefanrin@gmail.com> a écrit :
> > 
> > But in what order? If I understood correctly, with the single sync()
> > call, he might end up with a directory entry referencing an incomplete
> > file. Which should not be possible in the case with the two fsyncs.
> 
> In what order, this is exactly my question :)
> 
> We are creating hundreds or thousands of files in a row. Converting thousands of fsync() to one sync() would be a great performance improvement, but I want to be sure we are not taking any risk with data consistency.

I honestly don't remember on the top of my head, a sync() will cause the whole
XFS log to be flushed, and the flush order, I believe, will be according to how
the metadata got logged in. But, I do not believe it comes to the case. Reality
is, doesn't matter which is flushed first, file or directory metadata. If sync()
fails, you must assume nothing got flushed at all, and not 'guess' if something
got flushed in.
But, as I mentioned before, and also did Dave, unless you want to cause a whole
filesystem flush every time you have a file modified, use fsync() on the
specific files, instead a global sync().

Cheers


> 
> -- 
> Romain
> 

-- 
Carlos
