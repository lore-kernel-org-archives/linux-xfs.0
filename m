Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52959 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1956866AbdDZIVi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 04:21:38 -0400
Date: Wed, 26 Apr 2017 10:21:36 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 04/12] mkfs: merge tables for opts parsing into one table
Message-ID: <20170426082136.GZ28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-5-jtulak@redhat.com>
 <20170425030421.GH28800@wotan.suse.de>
 <CACj3i71jEx7aKBp4_bTk3KbHo1ne_Zj1r6y-=8iGLOkM2PujEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i71jEx7aKBp4_bTk3KbHo1ne_Zj1r6y-=8iGLOkM2PujEQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 09:45:53AM +0200, Jan Tulak wrote:
> On Tue, Apr 25, 2017 at 5:04 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > On Sun, Apr 23, 2017 at 08:54:55PM +0200, Jan Tulak wrote:
> >> opts[MAX_OPTS] = {
> >> +#define OPT_B        0
> >
> > I find these defines blinding on reading the struct declaration, we could
> > instead just stuff them into an enum, which would also enable us to shift all
> > the documentation into the header of the enum using whatever doc format we use.
> 
> The grouping is here to keep the style as it is with suboptions
> index/string. However, all these defines (OPT_X and X_FOO) are
> separated and moved into a single place later on in one patch anyway.
> I just didn't include that patch in this set as I had to make the line
> somewhere if I want to make multiple smaller and easier to review and
> merge sets rather than the one big monster as before.

Makes sense.

> There is one point I'm not sure about, though. We have to restart the
> counting for suboptions, like this:
> 
> enum subopts {
>   B_size = 0,
>   B_LOG,
>   D_AGCOUNT = 0,
>   D_...,
>   L_xxx = 0,
>   L_...,
> }
> 
> I didn't found anywhere if it is a good practice or not. But again, I
> just submitted it as it was with a note in my TODOs to find out more
> out it and update the patch changing it later on.

Ugh yeah no that would be pretty terrible, how about something like:

enum subopt_zero_idx {
	SUBOPT_ZERO_A = 0,
	SUBOPT_ZERO_B,
	SUBOPT_ZERO_C,
};

enum subopt_one_idx {
	SUBOPT_ONE_A = 0,
	SUBOPT_ONE_B,
};

enum subopt_two_idx {
	SUBOPT_TWO_A = 0,
};

union subopt_idx {
	enum subopt_zero_idx subopt_zero;
	enum subopt_one_idx subopt_one;
	enum subopt_two_idx subopt_two;
};

Demo: http://drvbp1.linux-foundation.org/~mcgrof/demos/demo-flexible-array-subopts.c 

 Luis
