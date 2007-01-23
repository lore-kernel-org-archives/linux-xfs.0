Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 19:28:02 -0800 (PST)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.191])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0N3Rtqw014708
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 19:27:57 -0800
Received: by nf-out-0910.google.com with SMTP id x30so87037nfb
        for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 19:27:02 -0800 (PST)
Message-ID: <e9c3a7c20701221744i7f0de470r4c8183dd3bcd20b5@mail.gmail.com>
Date: Mon, 22 Jan 2007 18:44:11 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
In-Reply-To: <17845.13256.284461.992275@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
	 <45B5261B.1050104@redhat.com>
	 <17845.13256.284461.992275@notabene.brown>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Neil Brown <neilb@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On 1/22/07, Neil Brown <neilb@suse.de> wrote:
> On Monday January 22, cebbert@redhat.com wrote:
> > Justin Piszcz wrote:
> > > My .config is attached, please let me know if any other information is
> > > needed and please CC (lkml) as I am not on the list, thanks!
> > >
> > > Running Kernel 2.6.19.2 on a MD RAID5 volume.  Copying files over Samba to
> > > the RAID5 running XFS.
> > >
> > > Any idea what happened here?
> ....
> > >
> > Without digging too deeply, I'd say you've hit the same bug Sami Farin
> > and others
> > have reported starting with 2.6.19: pages mapped with kmap_atomic()
> > become unmapped
> > during memcpy() or similar operations.  Try disabling preempt -- that
> > seems to be the
> > common factor.
>
> That is exactly the conclusion I had just come to (a kmap_atomic page
> must be being unmapped during memcpy).  I wasn't aware that others had
> reported it - thanks for that.
>
> Turning off CONFIG_PREEMPT certainly seems like a good idea.
>
Coming from an ARM background I am not yet versed in the inner
workings of kmap_atomic, but if you have time for a question I am
curious as to why spin_lock(&sh->lock)  is not sufficient pre-emption
protection for copy_data() in this case?

> NeilBrown

Regards,
Dan
