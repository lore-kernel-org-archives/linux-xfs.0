Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBE417F5F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 08:37:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7EE9304048
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 06:37:33 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id 3L1Oqtae6rcOPcWM (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Sep 2015 06:37:31 -0700 (PDT)
Date: Wed, 2 Sep 2015 23:37:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the block tree with the xfs tree
Message-ID: <20150902233729.4e824342@canb.auug.org.au>
In-Reply-To: <1441200891.17400.1277.camel@localhost.localdomain>
References: <20150902121649.7a686b6c@canb.auug.org.au>
	<C57DF728-E46C-433C-AA9D-209557D795E2@filmlight.ltd.uk>
	<20150902230342.125e23ce@canb.auug.org.au>
	<1441200891.17400.1277.camel@localhost.localdomain>
MIME-Version: 1.0
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Jens Axboe <axboe@kernel.dk>, David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-next@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Hi Roger,

On Wed, 02 Sep 2015 14:34:51 +0100 Roger Willcocks <roger@filmlight.ltd.uk> wrote:
>
> Huh, now I've had my coffee, that extra check doesn't add anything.
> (There's no harm done in assigning zero to io_error if it's already
> zero.) Apologies for the noise.

That's OK, my excuse is being to far at the other end of the day ...

I actually now remember thinking the same thing at the time I did it :-)
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
