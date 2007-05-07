Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 06:07:09 -0700 (PDT)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47D75fB011315
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 06:07:06 -0700
Received: by ug-out-1314.google.com with SMTP id t39so888009ugd
        for <xfs@oss.sgi.com>; Mon, 07 May 2007 06:07:04 -0700 (PDT)
Message-ID: <84144f020705070540tf3b1986yd4b1ab65e3a17d5e@mail.gmail.com>
Date: Mon, 7 May 2007 15:40:26 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 5/5] ext4: write support for preallocated blocks/extents
In-Reply-To: <20070426181623.GE7209@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070321120425.GA27273@amitarora.in.ibm.com>
	 <20070329101010.7a2b8783.akpm@linux-foundation.org>
	 <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070426181623.GE7209@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On 4/26/07, Amit K. Arora <aarora@linux.vnet.ibm.com> wrote:
>  /*
> + * ext4_ext_try_to_merge:
> + * tries to merge the "ex" extent to the next extent in the tree.
> + * It always tries to merge towards right. If you want to merge towards
> + * left, pass "ex - 1" as argument instead of "ex".
> + * Returns 0 if the extents (ex and ex+1) were _not_ merged and returns
> + * 1 if they got merged.
> + */
> +int ext4_ext_try_to_merge(struct inode *inode,
> +                               struct ext4_ext_path *path,
> +                               struct ext4_extent *ex)
> +{

Please either use proper kerneldoc format or drop
"ext4_ext_try_to_merge" from the comment.
