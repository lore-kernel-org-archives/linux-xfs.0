Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6F1977F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 14:57:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EC9A2AC001
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 12:57:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rRNj2tL1r2iThIp0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 12:57:43 -0700 (PDT)
Date: Wed, 29 Oct 2014 15:57:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfsprogs: don't warn about log sunit size if it was
	auto-discovered
Message-ID: <20141029195736.GC2084@bfoster.laptop>
References: <544FD3E1.1060000@redhat.com> <544FD47D.8020409@sandeen.net>
	<20141029183841.GB4226@bfoster.laptop>
	<545135D4.6010908@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <545135D4.6010908@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Stan Hoeppner <stan@hardwarefreak.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 29, 2014 at 01:45:40PM -0500, Eric Sandeen wrote:
> On 10/29/14 1:38 PM, Brian Foster wrote:
> > On Tue, Oct 28, 2014 at 12:38:05PM -0500, Eric Sandeen wrote:
> >> Today, users doing a bare mkfs on storage with a large default
> >> stripe size may be surprised to get this warning:
> >>
> >>  log stripe unit (%d bytes) is too large (maximum is 256KiB
> >>  log stripe unit adjusted to 32KiB
> >>
> >> through no fault of their own.  The fallback is appropriate
> >> and harmless, and there's no need to warn about this in the
> >> defaults case.
> >>
> >> However, we keep the warning if a large log stripe unit was
> >> specified by the user on the commandline.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> ...
> 
> >> @@ -2379,11 +2383,15 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
> >>  	}
> >>  
> >>  	if (logversion == 2 && (lsunit * blocksize) > 256 * 1024) {
> >> -		fprintf(stderr,
> >> +		/* Warn only if specified on commandline */
> >> +		if (lsuflag || lsunitflag) {
> >> +			fprintf(stderr,
> >>  	_("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"),
> >> -			(lsunit * blocksize));
> >> +				(lsunit * blocksize));
> >> +			fprintf(stderr,
> >> +	_("log stripe unit adjusted to 32KiB\n"));
> >> +		}
> > 
> > Right above this particular hunk we have the possibility of lsunit
> > inheriting a value from dsunit. If the latter is specified by the user,
> > we don't print the message for an arguably user-specified lsunit. Hmm,
> > do we care about that case?
> 
> I don't think we do care.  I think we only care if the user manually
> specified a log stripe unit and we're changing what they asked for.
> 
> I'd put "inheritance" in the "using default behaviors" case, and not
> warn about it.
> 

Ok, sounds sane. I was thinking there might be some utility to the
message for people with larger auto-detected stripe units, but we print
the geometry anyways and those users are clearly Ok with default
settings (Dave points out that 32k is the default).

The code looks Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
