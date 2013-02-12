Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7ACE97F7D
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 05:31:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0F6CAAC004
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 03:31:55 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FyHAp3qJ71g7N0eJ for
	<xfs@oss.sgi.com>; Tue, 12 Feb 2013 03:31:55 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1CBVsZg014030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Feb 2013 06:31:54 -0500
Date: Tue, 12 Feb 2013 12:31:52 +0100
From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
Message-ID: <20130212113152.GH20408@x2.net.home>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Tue, Feb 12, 2013 at 12:06:55PM +0100, Lukas Czerner wrote:
> +wipe_signatures(
> +	char		*device,
> +	int		dryrun)
> +{
> +	blkid_probe	pr = NULL;
> +	int		ret = 0;
> +	int		fd;
> +
> +	pr = blkid_new_probe_from_filename(device);
> +	if (!pr)
> +		goto out;
> +
> +	fd = open(device, O_RDWR|O_CLOEXEC);
> +	if (fd < 0) {
> +		ret = -1;
> +		goto out;
> +	}
> +	ret = blkid_probe_set_device(pr, fd, 0, 0);

 This does not make sense. The blkid_new_probe_from_filename() also
 opens (read-only) the device ;-)

 You need:

   pr = blkid_new_probe();
   if (!pr)
      goto out;

   fd = open(device, O_RDWR|O_CLOEXEC);
   if (fd < 0) {
		ret = -1;
		goto out;
   }
   ret = blkid_probe_set_device(pr, fd, 0, 0);


 Maybe you also need something like
 
   AC_CHECK_LIB(blkid, blkid_do_wipe, [have_blkidwipe=yes], [have_blkidwipe=no])

 or so, because old libblkid versions does not contain wipe stuff. See also
 m4/package_blkid.m4 in xfsprogs where is already check for blkid topology
 stuff.


 Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
