Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15HNDcR056550 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 11:23:14 -0600
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id YFdIFk25w5vHD6bY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 05 Feb 2012 09:23:12 -0800 (PST)
Date: Sun, 5 Feb 2012 18:23:02 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Message-ID: <20120205172302.GA7057@citd.de>
References: <4F2D8F30.3090802@redhat.com>
	<201202050933.q159XQpB026380@helium.internal.tigress.co.uk>
	<4F2EB017.5090006@redhat.com>
	<9C5B5C07-B0E4-4D13-BCFE-7F35162DF5E8@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9C5B5C07-B0E4-4D13-BCFE-7F35162DF5E8@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Eric Sandeen <sandeen@redhat.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Ron Yorston <rmy@tigress.co.uk>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05.02.2012 09:55, Andreas Dilger wrote:

> > Matthias' suggestion of adding SEEK_HOLE/SEEK_DATA makes very good sense too.
> 
> I thought about this, but if SEEK_HOLE/SEEK_DATA (or FIEMAP) worked, then the file would already be sparse, so I don't think that will help in this case...

With that argumentation you wouldn't need the tool in the first place.

"How can a bunch of zeros be in a file in the first place?"
"Can only be because of the deficiency of another program."

And who is to say that you wouldn't want to repeat such a thing from 
time to time, without SEEK_HOLE/SEEK_DATE you MAY crunch through big 
regions of zeros for no gain at all.



Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
