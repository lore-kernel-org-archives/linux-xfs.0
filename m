Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 34E2A7F37
	for <linux-xfs@oss.sgi.com>; Mon, 22 Jul 2013 16:22:55 -0500 (CDT)
Date: Mon, 22 Jul 2013 16:22:51 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs_metadump: manpage fix regarding frozen fs
Message-ID: <20130722212251.GF3111@sgi.com>
References: <51E4AD14.7080904@redhat.com> <20130719202055.GH3572@sgi.com>
	<87CEB35B-5931-49C9-8075-F44851F6E8ED@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87CEB35B-5931-49C9-8075-F44851F6E8ED@redhat.com>
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
To: Eric Sandeen <esandeen@redhat.com>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>

On Fri, Jul 19, 2013 at 07:34:57PM -0400, Eric Sandeen wrote:
> On Jul 19, 2013, at 3:20 PM, Ben Myers <bpm@sgi.com> wrote:
> 
> > Hey Eric,
> > 
> > On Mon, Jul 15, 2013 at 09:16:52PM -0500, Eric Sandeen wrote:
> >> The xfs_metadump manpage states that metadump works
> >> on a frozen filesystem; it does not.  In fact, there is
> >> no way to detect a frozen filesystem, so we can't make it
> >> work, either.
> >> 
> >> So just remove this from the manpage; unmounted or RO
> >> mounted is what is enforced by xfs_metadump.
> >> 
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > I gave this a try and it *seemed* to work fine on a frozen filesystem.
> > Can you provide a bit of detail about why xfs_metadump doesn't work on
> > frozen filesystems?  What am I missing?
> > 
> 
> Hum, when I tried it it didn't work.  I can retest, but AFAIK there is no way to detect a frozen fs in the first place, so how could it work?

Gah.  As we discussed on IRC, I was wrong.  So, so wrong.

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
