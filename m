Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9HF8434005270 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 10:08:04 -0500
Received: from smtprelay02.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C20A31D2178
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 08:08:03 -0700 (PDT)
Received: from smtprelay02.ispgateway.de (smtprelay02.ispgateway.de
	[80.67.31.29]) by cuda.sgi.com with ESMTP id RQBoiFqlvHJnPvBC
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 08:08:03 -0700 (PDT)
Message-ID: <4E9C44D0.7040904@cape-horn-eng.com>
Date: Mon, 17 Oct 2011 17:08:00 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: xfs_repair v3.1.6 - Segmentation fault AND XFS internal error
	xfs_btree_check_sblock
References: <4E9C3EEF.5080609@cape-horn-eng.com>
	<20111017150236.GA7056@infradead.org>
In-Reply-To: <20111017150236.GA7056@infradead.org>
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

On 10/17/2011 05:02 PM, Christoph Hellwig wrote:
> Can you send me a metadump of the filesystem?  It is generated using the
> xfs_metadump tool from xfsprogs, and obsfucates the file names used.
> Feel free to upload it to a private place and send the link and/or
> directly send it to me if you don't want to see it on the list.
> =


Hi, thanks for responding!

xfs_metadump also throws a Segmentation fault, both v3.1.6 and v3.1.4 :

# /opt/xfsprogs-3.1.6/sbin/xfs_metadump /dev/sdb1 xfs_metadump_dev-sdb1.log
*** stack smashing detected ***: xfs_db terminated
/opt/xfsprogs-3.1.6/sbin/xfs_metadump: line 31: 22049 Segmentation fault   =
   xfs_db$DBOPTS -F -i -p xfs_metadump -c "metadump$OPTS $2" $1


I will send the gzipped metadump file to you directly.

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
