Return-Path: <xfs-bounces@oss.sgi.com>
Date: Thu, 1 Aug 2013 10:11:28 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [pcp] Suggestions for SGI ICE where we need to get quota
	information
Message-ID: <20130801151128.GW3111@sgi.com>
References: <51F90B6A.6050809@sgi.com>
	<74641529.7203019.1375302856174.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <74641529.7203019.1375302856174.JavaMail.root@redhat.com>
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
To: Nathan Scott <nathans@redhat.com>
Cc: Jeff Hanson <jhanson@sgi.com>, PCP <pcp@oss.sgi.com>, mikeh@sgi.com, XFS <xfs@oss.sgi.com>

On Wed, Jul 31, 2013 at 04:34:16PM -0400, Nathan Scott wrote:
> ----- Original Message -----
> > In SGI's ICE product we have a script that uses pcp to gather quota
> > information to feed to ganglia and to alert the admin if a project is
> > over quota.  With newer pcp where pmcd is run as user pcp and not as
> > root we get failures to obtain the quota information.  Changing back
> > to root or other similar techniques works (as expected).  Since the
> > hosts that run this are cluster infrastructure nodes this may be the
> > hack we decide on but we'd like other suggestions.
> 
> [ http://oss.sgi.com/bugzilla/show_bug.cgi?id=985 ]
> 
> Hmm, interesting - sorry about that, its unintended fallout and it did
> not occur to me that the XFS quota metrics would be affected.  I would
> strongly recommend not going back to running pmcd as root, kittens will
> surely die (although it is likely to be your only solution currently).
> 
> There is a better way we can tackle this - we should isolate those
> parts that need to run as root, and run them that way.  This means we
> need to transition these quota metrics into a new PMDA which runs as
> root, separately to pmcd.
> 
> In a quirky twist, I happened to come across a very similar problem
> recently with the xfs.control.reset metric - this needs root access
> too in order to function (it provides a reset-stats-back-to-zero
> mechanism by writing to a procfs file), so it also was an unintended
> victim of the unprivileged-pmcd changes.
> 
> Thus, I propose we abstract out the xfs.* and quota.* (which, despite
> being generically named "quota" metrics, are all XFS-specific) into a
> new pmdaxfs which we run as root, in exactly the same way pmdaproc is
> now run as root.  We will need to manage the PMID transition (domain
> number on these metrics will change) via pmlogrewrite, but that is a
> well-trod path now and happily pmdaproc is an existence-proof that we
> can successfully make these transitions.
> 
> If we do it correctly, we should be able to do this transparently so
> that nobody notices.  However, Murphy being Murphy ... I've CC'd the
> XFS list to let 'em know this is coming.

Thanks Nathan, we'll keep an eye out.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
