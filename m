Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 277537F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 16:40:03 -0500 (CDT)
Date: Tue, 23 Jul 2013 16:40:02 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: RFE: the manpage claims no limits on size of file extended
	attributes; has this now true?
Message-ID: <20130723214002.GM3111@sgi.com>
References: <51EEF543.5020305@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51EEF543.5020305@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Hey Linda,

On Tue, Jul 23, 2013 at 02:27:31PM -0700, Linda Walsh wrote:
> Ok, lemme rephrase my questions...
> 
> The man page lists maximums for values at 64K, and names at 255
> characters.  This implies these are the only limits one need worry about
> -- i.e. there is no limit on the maximum number of 255 byte names nor is
> there a limit on the sum of the values of attributes.

To the best of my knowledge:

There is no limit on the maximum number of extended attribute names.

There is no limit on the sum of the values of attributes.

The limit is on the sum of the names and values of all of the attributes in a
given inode.

> Is it something like 2^60 bytes?

Yeah, it's something big like that.

> or some such limit that no one will ever hit?   Could
> I store alternate soundtracks for movies in attribute fields, or
> alternate scenes for movies?

Yep, you could do that.  It's just that it would have to be done in 64k chunks.
Some time ago there was some discussion of supporting multiple file streams
which would not have the unfortunate 64k limitation, but nothing has come of
it so far.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
