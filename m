Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 538BF7CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 14:35:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 29184304032
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 12:34:59 -0800 (PST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id TNTqZMzPowfAt8Cc
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Nov 2015 12:34:56 -0800 (PST)
Received: by wmvv187 with SMTP id v187so196179633wmv.1
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 12:34:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151116194846.GB32203@linux.intel.com>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
	<1447459610-14259-4-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4j4arHE+iAALn1WPDzSb_QSCDy8udtXU1FV=kYSZDfv8A@mail.gmail.com>
	<22E0F870-C1FB-431E-BF6C-B395A09A2B0D@dilger.ca>
	<CAPcyv4jwx3VzyRugcpH7KCOKM64kJ4Bq4wgY=iNJMvLTHrBv-Q@mail.gmail.com>
	<20151116133714.GB3443@quack.suse.cz>
	<20151116140526.GA6733@quack.suse.cz>
	<CAPcyv4jZjnkz2YYtGWmkA23KAUMT092kjRtFkJ3QrzgPfTucfA@mail.gmail.com>
	<20151116194846.GB32203@linux.intel.com>
Date: Mon, 16 Nov 2015 12:34:55 -0800
Message-ID: <CAPcyv4hU0HMBFy=MveUaECK0fVfgUFBjUUPTWA8HOP6MG5XEfQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] pmem: enable REQ_FUA/REQ_FLUSH handling
From: Dan Williams <dan.j.williams@intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "J. Bruce Fields" <bfields@fieldses.org>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <willy@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, XFS Developers <xfs@oss.sgi.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>

On Mon, Nov 16, 2015 at 11:48 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Mon, Nov 16, 2015 at 09:28:59AM -0800, Dan Williams wrote:
>> On Mon, Nov 16, 2015 at 6:05 AM, Jan Kara <jack@suse.cz> wrote:
>> > On Mon 16-11-15 14:37:14, Jan Kara wrote:
[..]
> Is there any reason why this wouldn't work or wouldn't be a good idea?

We don't have numbers to support the claim that pcommit is so
expensive as to need be deferred, especially if the upper layers are
already taking the hit on doing the flushes.

REQ_FLUSH, means flush your volatile write cache.  Currently all I/O
through the driver never hits a volatile cache so there's no need to
tell the block layer that we have a volatile write cache, especially
when you have the core mm taking responsibility for doing cache
maintenance for dax-mmap ranges.

We also don't have numbers on if/when wbinvd is a more performant solution.

tl;dr Now that we have a baseline implementation can we please use
data to make future arch decisions?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
