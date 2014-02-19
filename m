Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2AFD47FCA
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 15:58:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 152BF8F8074
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 13:58:15 -0800 (PST)
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com
	[209.85.223.180]) by cuda.sgi.com with ESMTP id
	K24XqhYDDSDxyzyq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Feb 2014 13:58:15 -0800 (PST)
Received: by mail-ie0-f180.google.com with SMTP id ar20so707921iec.39
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 13:58:14 -0800 (PST)
Date: Wed, 19 Feb 2014 22:58:05 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
Subject: Re: [PATCH v5 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
Message-ID: <20140219215805.GA1714@gmail.com>
References: <1392741489-20097-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392741489-20097-1-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, Ashish Sangwan <a.sangwan@samsung.com>, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

Hi Namjae,
see below:

On 19.02.2014 01:38, Namjae Jeon wrote:
> This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for Ext4.
...<snip>...
> +	/*
> +	 * Don't start shifting extents until we make sure the hole is big
> +	 * enough to accomodate the shift.
> +	 */
> +	path = ext4_ext_find_extent(inode, start - 1, NULL, 0);
> +	depth = path->p_depth;
> +	extent =  path[depth].p_ext;
> +	ex_start = extent->ee_block;
> +	ex_end = extent->ee_block + ext4_ext_get_actual_len(extent);
> +	ext4_ext_drop_refs(path);
> +	kfree(path);
> +
> +	if ((start == ex_start && shift > ex_start) ||
> +	    (shift > start - ex_end)) {

This line causes a compile error. So the fix would be like that:

-	    (shift > start - ex_end)) {
+	    (shift > start - ex_end))

> +		return -EINVAL;
> +
> +	/* Its safe to start updating extents */
...<snip>...

Apart from that, the whole patchset seems to work without error,
both on xfs and on ext4.
Of course I had to remove Lukas' patches before testing collapse-range.
So it would be excellent if two patch series could get somehow merged.

Tested-by: Dongsu Park <dongsu.park@profitbricks.com>

Regards,
Dongsu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
