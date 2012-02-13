Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DHBWHr026473 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 11:11:33 -0600
Received: from smtprelay03.ispgateway.de (smtprelay03.ispgateway.de
	[80.67.31.41]) by cuda.sgi.com with ESMTP id vFVd2JM59S2RNw7I
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 09:11:32 -0800 (PST)
Message-ID: <4F394442.9020307@cape-horn-eng.com>
Date: Mon, 13 Feb 2012 18:11:30 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <4F394116.8080200@cape-horn-eng.com>
	<20120213170825.GA7197@infradead.org>
In-Reply-To: <20120213170825.GA7197@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 02/13/2012 06:08 PM, Christoph Hellwig wrote:
> On Mon, Feb 13, 2012 at 05:57:58PM +0100, Richard Ems wrote:
>> This is a backup system running dirvish, so most files in the dirs I am
>> removing are hard links. Almost all of the files do have ACLs set.
> =

> How many ACLs do you usually have set?  If they aren't stored inline
> but need to go out of the inode unlinks will be extremly slow for
> kernels before v3.2.
> =


Almost all dirs and files there do have ACLs set.
Each of them do have about 10 user ACLs and 10 default ACls.
Is that too many?
Is this then the reason for being that slow?
Will updating to a kernel > 3.2 improve the unlink speed?

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
