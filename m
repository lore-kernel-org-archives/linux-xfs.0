Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0866D7F5A
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 19:03:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF0C88F80CE
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 17:02:59 -0800 (PST)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	CoY8yha69U0KhSTm for <xfs@oss.sgi.com>;
	Fri, 13 Nov 2015 17:02:53 -0800 (PST)
Subject: Re: [PATCH v2 02/11] mm: add pmd_mkclean()
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
	<1447459610-14259-3-git-send-email-ross.zwisler@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <56468838.6010506@intel.com>
Date: Fri, 13 Nov 2015 17:02:48 -0800
MIME-Version: 1.0
In-Reply-To: <1447459610-14259-3-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On 11/13/2015 04:06 PM, Ross Zwisler wrote:
> +static inline pmd_t pmd_mkclean(pmd_t pmd)
> +{
> +	return pmd_clear_flags(pmd, _PAGE_DIRTY | _PAGE_SOFT_DIRTY);
> +}

pte_mkclean() doesn't clear _PAGE_SOFT_DIRTY.  What the thought behind
doing it here?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
