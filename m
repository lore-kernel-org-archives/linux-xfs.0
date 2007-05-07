Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 06:04:30 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47D4PfB010686
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 06:04:26 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l47D4Odp031307
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 09:04:24 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l47D4ObH130260
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 07:04:24 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l47D4NSZ024479
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 07:04:23 -0600
Date: Mon, 7 May 2007 18:34:29 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/5] ext4: write support for preallocated blocks/extents
Message-ID: <20070507130429.GA6681@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181623.GE7209@amitarora.in.ibm.com> <84144f020705070540tf3b1986yd4b1ab65e3a17d5e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020705070540tf3b1986yd4b1ab65e3a17d5e@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Mon, May 07, 2007 at 03:40:26PM +0300, Pekka Enberg wrote:
> On 4/26/07, Amit K. Arora <aarora@linux.vnet.ibm.com> wrote:
> > /*
> >+ * ext4_ext_try_to_merge:
> >+ * tries to merge the "ex" extent to the next extent in the tree.
> >+ * It always tries to merge towards right. If you want to merge towards
> >+ * left, pass "ex - 1" as argument instead of "ex".
> >+ * Returns 0 if the extents (ex and ex+1) were _not_ merged and returns
> >+ * 1 if they got merged.
> >+ */
> >+int ext4_ext_try_to_merge(struct inode *inode,
> >+                               struct ext4_ext_path *path,
> >+                               struct ext4_extent *ex)
> >+{
> 
> Please either use proper kerneldoc format or drop
> "ext4_ext_try_to_merge" from the comment.

Ok, Thanks.

--
Regards,
Amit Arora
