Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45392 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728161AbeJWDou (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Oct 2018 23:44:50 -0400
Subject: Re: xfsdump cleaning patchset
From: Eric Sandeen <sandeen@sandeen.net>
References: <CACj3i73FyABTkX1eCDvL+ccUhD1kWowS92=PFVyGiPvi6HWGFQ@mail.gmail.com>
 <20181022174316.GA28561@infradead.org>
 <90559dfb-5222-4faf-a9bb-a314cc645129@sandeen.net>
Message-ID: <83eb725e-800d-b597-29d9-52d8a672c82c@sandeen.net>
Date: Mon, 22 Oct 2018 14:25:00 -0500
MIME-Version: 1.0
In-Reply-To: <90559dfb-5222-4faf-a9bb-a314cc645129@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 10/22/18 1:07 PM, Eric Sandeen wrote:
> On 10/22/18 12:43 PM, Christoph Hellwig wrote:
>> Please send an actual patch series, github is completely unusable
> 
> Sorry, I had asked Jan to put up a git tree first as a sanity
> check before sending $UNKNOWN_NR patches to the list, I just
> wanted to quickly get a sense of the work he'd done, and have
> the full patch series sent if it looked like it was on the right
> path.
> 
> So, my bad.
> 
> -Eric
> 

I mostly just wanted to see how it was broken up and the patch
style, which looks mostly ok.  But while we're here:

First, what testing was done on the patchset?

For Coverity issues, please use:

Addresses-Coverity-ID: XYZ

or even i.e.

Addresses-Coverity-ID: XYZ ("Missing break in switch")

in the body instead of putting the CID in the subject (which wasn't
done consistently in any case).  It'd be good to have the coverity
ID in each patch that addresses one; more than one CID mentioned
via several patch tags is fine.


I'd also kind of hoped to do more whitespace/style fixup before
making code changes but that'll make your later patches impossible
to apply, so maybe we'll just leave it for now.


I'm not a huge fan of "fix buffer overflows by making them arbitrarily
bigger" - can we use i.e. snprintf to make sure it won't happen again,
and maybe size them based on ... something, instead of "eh, [5000] is
hopefully enough?"

i.e. in 

df48737f  xfsdump: fix string truncation 

"cmd" gets:

snprintf(cmd, sizeof(cmd), "cp %s %s", stobjfile, dst_stobjfile);

Each of those is up to MAXPATHLEN, which (I think) is 4096,
so even your 5000 isn't enough in extreme cases.  OTOH you may not
want a 2*4096+5 array on the stack, so maybe it should be allocated.
Or, maybe system("cp A B") is crazy in the first place, don't we have
rename() for that purpose?

In the same file, 

-static char txt[256];
+static char txt[300];

we snprintf to txt in 3 places:

snprintf(txt, sizeof(txt), "path:  %s", invtentry->ie_filename);
ie_filename is 128 chars so this should be fine.

and 2 more similar to:
snprintf(txt, sizeof(txt), "start: %s", ctime32(&invtentry->ie_timeperiod.tp_start));

where "ctime32" calls ctime() which in general isn't going to be returning
anywhere near 250 bytes, so it's not clear why 300 is any "better."

similar for the change to:

#define MAX_UNAMECMD MAXHOSTLEN+40

there is no indication that "+100" is sufficient - rsh_path could again
be up to PATH_MAX.  For this kind of stuff don't guess, either figure out
the max, or gracefully detect an overflow and use error handling if it does,
or find a way to do it that doesn't require allocating 10k of buffer
on the stack.  ;)


>From spot-checking a few commits, please take another careful pass
through to look at context and code history to be sure that you're
really fixing the code properly and not just making coverity and/or
gcc be quiet; for example in

0ab032a8 common/drive_minrmt.c: remove a dead code (CID 1056289) 

you saw that coverity spotted dead code and so you removed it, but it
shouldn't be dead, it should be somewhere else, I think - look up about
30 lines from your change for a hint.  :)


For some of the resource leak fixes, you might consider using something
like "goto out_free;" rather than adding cleanup repeatedly at multiple
return points.  Sometimes that's cleaner.


TBH each of these is going to take careful review, nobody really
knows how xfsdump works anymore so we'll have to be very careful that
nothing breaks.

Anyway, give it another check through, make sure you understand the
code you're changing to be sure you aren't just taking the fast path
to making coverity shut up, reformat the changelogs as above, be ready
to tell us what fairly comprehensive testing you did on the result, and we
can take a pass at review on the list.


Thanks,
-Eric
