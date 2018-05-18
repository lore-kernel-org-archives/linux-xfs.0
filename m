Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751531AbeERWGx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 May 2018 18:06:53 -0400
Date: Sat, 19 May 2018 00:06:51 +0200
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH v2 1/2] vfs: allow dedupe of user owned read-only files
Message-ID: <20180518220651.GC28045@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20180518215727.26418-1-mfasheh@suse.de>
 <20180518215727.26418-2-mfasheh@suse.de>
 <20180518220338.GA31250@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518220338.GA31250@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>

On Fri, May 18, 2018 at 03:03:38PM -0700, Darrick J. Wong wrote:
> > +/* Check whether we are allowed to dedupe the destination file */
> > +static int allow_file_dedupe(struct file *file)
> 
> Shouldn't this return bool?  It's a predicate, after all...

Yeah that should be bool. Thanks for pointing it out, I'll fix it up in the
next round.
	--Mark
