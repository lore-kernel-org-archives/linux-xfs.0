Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753987AbdLDQSl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Dec 2017 11:18:41 -0500
Date: Mon, 4 Dec 2017 17:18:39 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: Display project quotas without
Message-ID: <20171204161839.GC17047@quack2.suse.cz>
References: <CAL4D3QFpES1U1pCQ3md2Jiiqm0E5L5KhG4T77gnyEiom-EZBgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL4D3QFpES1U1pCQ3md2Jiiqm0E5L5KhG4T77gnyEiom-EZBgw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Romeo Theriault <romeotheriault@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Wed 22-11-17 02:52:40, Romeo Theriault wrote:
> Hello, Is it possible to display project quotas without the
> /etc/projid file? I have a need to display the quotas without this (or
> the /etc/project file) and just display the quotas with the id's.
> 
> For example,
> 
> xfs_quota -x -c 'report -p'
> 
> displays nothing until I add a /etc/projid file.
> 
> Anyway around this? Using xfs_db or xfs_io somehow?

Well, you could install recent version of quota-tools and then use
repquota(8) command to display quotas. It works also for XFS and does not
need /etc/projid file.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
