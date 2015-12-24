Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94BF929DF5
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 18:28:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 847798F8035
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 16:28:55 -0800 (PST)
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
	by cuda.sgi.com with ESMTP id WRMRB1V2WYb3O0cT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Dec 2015 16:28:53 -0800 (PST)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v6 3/7] mm: add find_get_entries_tag()
Date: Thu, 24 Dec 2015 00:28:24 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BEC9A58@G9W0745.americas.hpqcorp.net>
References: <1450899560-26708-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450899560-26708-4-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1450899560-26708-4-git-send-email-ross.zwisler@linux.intel.com>
Content-Language: en-US
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "x86@kernel.org" <x86@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Jan Kara <jack@suse.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Ross Zwisler
> Sent: Wednesday, December 23, 2015 1:39 PM
> Subject: [PATCH v6 3/7] mm: add find_get_entries_tag()
> 
...
> diff --git a/mm/filemap.c b/mm/filemap.c
...
> +unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
> +			int tag, unsigned int nr_entries,
> +			struct page **entries, pgoff_t *indices)
> +{
> +	void **slot;
> +	unsigned int ret = 0;
...
> +	radix_tree_for_each_tagged(slot, &mapping->page_tree,
> +				   &iter, start, tag) {
...
> +		indices[ret] = iter.index;
> +		entries[ret] = page;
> +		if (++ret == nr_entries)
> +			break;
> +	}

Using >= would provide more safety from buffer overflow
problems in case ret ever jumped ahead by more than one.
---
Robert Elliott, HPE Persistent Memory

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
