Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E36CDB47E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 07:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjJLHep (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 03:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbjJLHeo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 03:34:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7667A90
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 00:34:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15A4C433C9;
        Thu, 12 Oct 2023 07:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697096082;
        bh=Xi39sy6oiDYutAM3dpEDKPXI+/aQZHWFGVRwR30E7qs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fXp7F39JpJgcUyY10FQU5yS6CoKKmZFpzuJFnohQdfyT+JUUVQdxH7btLl/+E9IU5
         fSkyu7cbb5KxMmVn6vE8HLrNiWncfIkCz7ypHERtuxmpk7ga2MN/BR7J+/TWWk8pWM
         YC+5bQl21cBdgdYbgOjdXux/+7GMtq+kg0rVZrAfcuIV2aLpr/nl4BNV/UcvcWhm7Y
         sEXr4XfNQcYU8TjW/XyEf43IvgRZ1YsWDYXBxXV9O74hguu8i/l2dbDHlCdyg01KkG
         XEzHWK5lvzMKmQQf3qIV9exuwZciDv+a5yUYPOUTOKmGGJi+eF0Mhda/fubineqxMC
         0df9WddCcNCgA==
Date:   Thu, 12 Oct 2023 00:34:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 09/28] fsverity: pass log_blocksize to
 end_enable_verity()
Message-ID: <20231012073440.GB2100@sol.localdomain>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-10-aalbersh@redhat.com>
 <20231011031906.GD1185@sol.localdomain>
 <bwwev42i7ahrbdl4kvl7sc27zwrg7btmwf2j5h2grxp25mxxpl@4loq5hqs43gv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bwwev42i7ahrbdl4kvl7sc27zwrg7btmwf2j5h2grxp25mxxpl@4loq5hqs43gv>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 01:17:36PM +0200, Andrey Albershteyn wrote:
> On 2023-10-10 20:19:06, Eric Biggers wrote:
> > On Fri, Oct 06, 2023 at 08:49:03PM +0200, Andrey Albershteyn wrote:
> > > diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> > > index 252b2668894c..cac012d4c86a 100644
> > > --- a/include/linux/fsverity.h
> > > +++ b/include/linux/fsverity.h
> > > @@ -51,6 +51,7 @@ struct fsverity_operations {
> > >  	 * @desc: the verity descriptor to write, or NULL on failure
> > >  	 * @desc_size: size of verity descriptor, or 0 on failure
> > >  	 * @merkle_tree_size: total bytes the Merkle tree took up
> > > +	 * @log_blocksize: log size of the Merkle tree block
> > >  	 *
> > >  	 * If desc == NULL, then enabling verity failed and the filesystem only
> > >  	 * must do any necessary cleanups.  Else, it must also store the given
> > > @@ -65,7 +66,8 @@ struct fsverity_operations {
> > >  	 * Return: 0 on success, -errno on failure
> > >  	 */
> > >  	int (*end_enable_verity)(struct file *filp, const void *desc,
> > > -				 size_t desc_size, u64 merkle_tree_size);
> > > +				 size_t desc_size, u64 merkle_tree_size,
> > > +				 u8 log_blocksize);
> > 
> > Maybe just pass the block_size itself instead of log2(block_size)?
> 
> XFS will still do `index << log2(block_size)` to get block's offset.
> So, not sure if there's any difference.

It's only used in the following:

	offset = 0;
	for (index = 1; offset < merkle_tree_size; index++) {
		xfs_fsverity_merkle_key_to_disk(&name, offset);
		args.name = (const uint8_t *)&name.merkleoff;
		args.attr_filter = XFS_ATTR_VERITY;
		error = xfs_attr_set(&args);
		offset = index << log_blocksize;
	}

... which can be the following instead:

	for (offset = 0; offset < merkle_tree_size; offset += block_size) {
		xfs_fsverity_merkle_key_to_disk(&name, offset);
		args.name = (const uint8_t *)&name.merkleoff;
		args.attr_filter = XFS_ATTR_VERITY;
		error = xfs_attr_set(&args);
	}
