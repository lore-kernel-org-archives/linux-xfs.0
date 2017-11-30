Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47906 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753002AbdK3AXE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 19:23:04 -0500
Date: Thu, 30 Nov 2017 01:22:59 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 05/11] fs: add iterate_supers_excl() and
 iterate_supers_reverse_excl()
Message-ID: <20171130002259.GY729@wotan.suse.de>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <20171129232356.28296-6-mcgrof@kernel.org>
 <CAJZ5v0gO49=pXGEdi42Hka=Rf=SqVWp-QSJf9_+bGuOgsHMFig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0gO49=pXGEdi42Hka=Rf=SqVWp-QSJf9_+bGuOgsHMFig@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, bart.vanassche@wdc.com, ming.lei@redhat.com, Ted Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jiri Kosina <jikos@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, linux-fsdevel@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Todd Brandt <todd.e.brandt@linux.intel.com>, nborisov@suse.com, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Oliver Neukum <ONeukum@suse.com>, oleksandr@natalenko.name, Oleg Antonyan <oleg.b.antonyan@gmail.com>, Yu Chen <yu.chen.surf@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Linux PM <linux-pm@vger.kernel.org>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Nov 30, 2017 at 12:48:15AM +0100, Rafael J. Wysocki wrote:
> On Thu, Nov 30, 2017 at 12:23 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > +int iterate_supers_excl(int (*f)(struct super_block *, void *), void *arg)
> > +{
> > +       struct super_block *sb, *p = NULL;
> > +       int error = 0;
> > +
> > +       spin_lock(&sb_lock);
> > +       list_for_each_entry(sb, &super_blocks, s_list) {
> > +               if (hlist_unhashed(&sb->s_instances))
> > +                       continue;
> > +               sb->s_count++;
> > +               spin_unlock(&sb_lock);
> 
> Can anything bad happen if the list is modified at this point by a
> concurrent thread?

The race is theoretical and applies to all users of iterate_supers() as well.

Its certainly worth considering, however given other code is implicated its
not a *new* issue or race. Its the best we can do with the current design.

That said, as I looked at all this code I considered that perhaps super_blocks
deserves its own RCU lock to enable us to do full swap operations on the list,
without having to do these nasty releases in between.

If that's possible / desirable I'd consider it a welcomed future optimization,
and I could give it a shot, however its unclear if this is a requirement for
this feature at this time.

  Luis
