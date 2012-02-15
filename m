Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FC7l5n174286 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 06:07:47 -0600
Received: from smtprelay01.ispgateway.de (smtprelay01.ispgateway.de
	[80.67.31.28]) by cuda.sgi.com with ESMTP id v8XMyCWqIB2UJAIZ
	for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 04:07:46 -0800 (PST)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1RxdeD-0006hS-EW
	for xfs@oss.sgi.com; Wed, 15 Feb 2012 13:07:45 +0100
Message-ID: <4F3BA011.8010006@cape-horn-eng.com>
Date: Wed, 15 Feb 2012 13:07:45 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <4F394116.8080200@cape-horn-eng.com>
	<20120214000924.GF14132@dastard> <4F3A5440.409@cape-horn-eng.com>
	<20120214194535.GB7399@infradead.org>
In-Reply-To: <20120214194535.GB7399@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 02/14/2012 08:45 PM, Christoph Hellwig wrote:
> On Tue, Feb 14, 2012 at 01:32:00PM +0100, Richard Ems wrote:
>>> You won't if the directory traversal is seek bound and that is the
>>> limiting factor for performance.
>>
>> *Seek bound*? *When* is the directory traversal *seek bound*?
> =

> You read the inode for the directory first, then the external attribute
> block for the ACLs, then if the directory isn't tiny you'll start reading
> directory blocks, the more the larger the directory is, and if the
> filesystem is close to beeing full they often will be non-contiguous.
> Then you read the inode for each file/directory in it, then the external
> attribute block, then the extent list, and so on.

Ok, got it.

Many thanks,
Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
