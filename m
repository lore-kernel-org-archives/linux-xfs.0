Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9324hKc122481 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 21:04:43 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id NfhT45eOHlx6BwFA for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 19:06:06 -0700 (PDT)
Message-ID: <506B9D98.6040808@sandeen.net>
Date: Tue, 02 Oct 2012 21:06:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
References: <506B1A03.7030600@tlinx.org> <20121002201748.GQ23520@dastard>
	<506B5CA0.7050306@tlinx.org>
In-Reply-To: <506B5CA0.7050306@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/2/12 4:29 PM, Linda Walsh wrote:
> 
> 
> Dave Chinner wrote:
>> $ sudo xfs_db -r /dev/vdb
>> xfs_db> inode 128
>> (reverse-i-search)`in': inode 128
> ----
> Um...When I press up-arrow, I get nothing.
> 
> When I press down arrow -- also nothing.
> 
> Try hitting home for beginning of line --
> nothing.   Tried ESC to re-edit line -- nothing. (enters ^[).
> 
> What are you typing to get the above?  does it require a config somewhere?

Do you build your own pkgs or use a distro?  IF distro, I'd file a bug.

Agreed that defaulting to on would be nice, but in Fedora & RHEL:

%configure \
        --enable-readline=yes	\
...

just FWIW.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
