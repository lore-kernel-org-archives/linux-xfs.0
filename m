Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51458 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935560AbeFMOW0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 10:22:26 -0400
Subject: Re: Reading/changing projid of a symlink
References: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
 <20180612143608.ok3jqtl3l34vdlpy@odin.usersys.redhat.com>
 <CA+Xn3kyxiOj+irNiqKWQWfJ_aUv1RYFsH+UCnv3gnMuYJ=oUQw@mail.gmail.com>
 <20180613062341.GA24317@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c82e193c-a302-d920-eba6-fedc719ba7f9@sandeen.net>
Date: Wed, 13 Jun 2018 09:22:24 -0500
MIME-Version: 1.0
In-Reply-To: <20180613062341.GA24317@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Ilya Pronin <ipronin@twitter.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>

On 6/13/18 1:23 AM, Christoph Hellwig wrote:
> On Tue, Jun 12, 2018 at 03:17:27PM -0700, Ilya Pronin wrote:
>> So the only way to remove a symlink from a project is to remove it?
> 
> Yes.

Dumb question, should symlinks even /be/ in projects?

If it can't be manipulated from userspace, should it be inherited
in kernelspace (I assume that's how it got set?)

I ... guess it's needed for inode accounting, still?

-Eric
