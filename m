Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5434729DF5
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 16:46:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 355B98F8040
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 14:46:14 -0800 (PST)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	ZO8Pow1V8r8C0GiD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2015 14:46:13 -0800 (PST)
Date: Tue, 22 Dec 2015 14:46:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3/7] mm: add find_get_entries_tag()
Message-Id: <20151222144611.07002cfde41d035125da2fa5@linux-foundation.org>
In-Reply-To: <1450502540-8744-4-git-send-email-ross.zwisler@linux.intel.com>
References: <1450502540-8744-1-git-send-email-ross.zwisler@linux.intel.com>
	<1450502540-8744-4-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@ml01.01.org, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri, 18 Dec 2015 22:22:16 -0700 Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> Add find_get_entries_tag() to the family of functions that include
> find_get_entries(), find_get_pages() and find_get_pages_tag().  This is
> needed for DAX dirty page handling because we need a list of both page
> offsets and radix tree entries ('indices' and 'entries' in this function)
> that are marked with the PAGECACHE_TAG_TOWRITE tag.
> 
> ...
>
> +EXPORT_SYMBOL(find_get_entries_tag);

This is actually a pretty crappy name because it doesn't describe what
subsystem it belongs to.  scheduler?  scatter/gather?  filesystem?

But given what we've already done, I don't see an obvious fix.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
