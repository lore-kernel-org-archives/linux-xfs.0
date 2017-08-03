Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44410 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751696AbdHCUrC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Aug 2017 16:47:02 -0400
Date: Thu, 3 Aug 2017 22:47:00 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 6/7] mkfs: extend opt_params with a value field
Message-ID: <20170803204700.GC27873@wotan.suse.de>
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-7-jtulak@redhat.com>
 <20170727161806.GJ18884@wotan.suse.de>
 <30eae9db-14fd-b245-3aab-5c1670894b44@redhat.com>
 <20170729170241.GM18884@wotan.suse.de>
 <27945607-28e6-31ec-7844-b63a729d040c@redhat.com>
 <20170802165716.GF18884@wotan.suse.de>
 <4f4baa41-335a-5906-a5f7-45e01d9ce88f@redhat.com>
 <20170802194848.GI18884@wotan.suse.de>
 <bf198f37-1080-d983-50a3-7be77d87ca2e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf198f37-1080-d983-50a3-7be77d87ca2e@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Thu, Aug 03, 2017 at 03:23:24PM +0200, Jan Tulak wrote:
> On 02/08/2017 21:48, Luis R. Rodriguez wrote:
> > I think it will be silly to add config support without
> > having the ability to catch errors and then indicate on its own however it
> > chooses exactly where the error occurred.
> I fully agree. We differ only in the opinion if it is important to do it
> right now, or if it would be better as a standalone change.

Not really, I don't care when it goes in so long as there is commitment
to follow up to do that missing piece of work. The config file parsing
thing can wait until this is all done, but it depends on it.

> > Will you take on doing the error code changes after ?
> > 
> I put it into my todo list. Maybe it is not going to be the very next patch
> set, but it is there.

OK cool! Then sure!

  Luis
