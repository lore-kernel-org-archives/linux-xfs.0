Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 14:06:53 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7GL6TDW009715
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 14:06:30 -0700
Received: by nf-out-0910.google.com with SMTP id a25so845756nfc
        for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 14:05:59 -0700 (PDT)
Message-ID: <9a8748490608161405s4c4ad5f5l405c6d5a7d56396@mail.gmail.com>
Date: Wed, 16 Aug 2006 23:05:59 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: review: cleanup xfs_da_node_lookup_int (was Re: [PATCH] XFS: possibly uninitialized variable use in fs/xfs/xfs_da_btree.c::xfs_da_node_lookup_int())
In-Reply-To: <20060814155609.G2698880@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200608122334.21901.jesper.juhl@gmail.com>
	 <44DE9B86.90006@sandeen.net>
	 <20060814155609.G2698880@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 14/08/06, Nathan Scott <nathans@sgi.com> wrote:
> On Sat, Aug 12, 2006 at 10:24:54PM -0500, Eric Sandeen wrote:
> > ...
> > FWIW seems like there's a lot of unnecessary endian flipping in there too; I
> > haven't tested this but since it endian-flips the magic into blk->magic seems
> > like it may as well use it:
>
> How's this look?
>
As far as I can see it looks good, but I'm still just starting to read
the XFS code, so I'm far from reliable yet  ;-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
