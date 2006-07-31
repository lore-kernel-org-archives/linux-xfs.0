Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Jul 2006 15:29:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6VMSbDW000514
	for <xfs@oss.sgi.com>; Mon, 31 Jul 2006 15:28:48 -0700
Date: Tue, 1 Aug 2006 08:27:47 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: Where are superblocks stored?
Message-ID: <20060801082747.B2286470@wobbly.melbourne.sgi.com>
References: <51A9A4FCBC06324F8BFE956A551B58E0056A4CA3@mail01dn.adic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A9A4FCBC06324F8BFE956A551B58E0056A4CA3@mail01dn.adic.com>; from rishi.malik@adic.com on Mon, Jul 31, 2006 at 09:23:27AM -0600
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rishi Malik <rishi.malik@adic.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 31, 2006 at 09:23:27AM -0600, Rishi Malik wrote:
> Hi All,
> 
> I'm investigating some compact flash failures we've had. We run XFS on
> the CF. I've been getting a lot of I/O errors around logical block
> 543080. These are 512MB compact flash cards, and I think that block puts
> it at about halfway through the CF. I know the I/O errors indicate an

That would be the journal.

> error at a lower level then XFS. What I'm wondering, is if there's a
> superblock stored there? Maybe we're hammering that area a lot, and
> because of other problems with the card, we're getting these errors. 
> 
> I know that XFS stores its primary superblock at 0, but I haven't found
> out where the secondary superblocks are stored. Any help is appreciated.

The secondary superblocks are very rarely touched (repair, and
growfs only IIRC), they will be unrelated to your problem here.

cheers.

-- 
Nathan
