Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o97Lempg227216 for <xfs@oss.sgi.com>; Thu, 7 Oct 2010 16:40:48 -0500
Subject: Re: XFS Filename Hash and metadump
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <201010052328.34390@zmi.at>
References: <1286290547.1960.3.camel@doink>  <201010052328.34390@zmi.at>
Date: Thu, 07 Oct 2010 16:41:49 -0500
Message-ID: <1286487709.2670.407.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, 2010-10-05 at 23:28 +0200, Michael Monnerie wrote:
> On Dienstag, 5. Oktober 2010 Alex Elder wrote:
> > PS  Two more observations:
> >     - There is really no need for the characters to be truly random.
> >       Making the generated name unique and different from the
> >       original is sufficient.  So (with the exception of the last
> >       five bytes) we can select the characters however we like.
> >       They could be a sequential series of names, for example,
> >       rather than computing a random value for each.
> 
> I was thinking the same when reading your description. Why not simply 
> "number" the file names from 1 to whatever count of files/dirs there is 
> within that dir?
> 

I'm not entirely sure how best to implement it, and I'm open to
suggestions.

As a starting point, I will make it so the random characters making
up the first part of the name are printable, and could probably restrict
it even more than that (say, using lower-case alphabetic and numeric
characters).

A scheme with incrementing file names would need to accomodate names of
arbitrary length, too, and it might be better to make the varying part
be at the front of such names.

We need to be aware that there could be duplicates (filenames hashing
to the same value), even though that's unlikely.

In any case the last four and a half bytes of the name will need to
be in the full 8-bit range to make the hash work out right.

I have a few ideas for all of the above.  They didn't get out in my
first draft of the patch series because like I said I wanted to get
early feedback rather than waiting to get other stuff implemented.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
