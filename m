Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Sep 2006 13:20:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8JKKpaG008310
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 13:20:53 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22947D17675C
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 13:20:10 -0700 (PDT)
Received: from agami.com ([192.168.168.132])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8JKK62c026002
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 13:20:08 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8JKK1Zb005927
	for <xfs@oss.sgi.com>; Tue, 19 Sep 2006 13:20:01 -0700
Message-ID: <451050E7.40806@agami.com>
Date: Wed, 20 Sep 2006 01:49:51 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: swidth with mdadm and RAID6
References: <Pine.LNX.4.10.10609191517590.2460-100000@limpet.umeoce.maine.edu>
In-Reply-To: <Pine.LNX.4.10.10609191517590.2460-100000@limpet.umeoce.maine.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: cousins@umit.maine.edu
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Steve Cousins wrote:

>>a 2.6.17 kernel.  So, with this in mind, is there a change that I
>>should try in libdisk/md.c?  Tim had suggested:
>>
>>	s/nr_disks/raid_disks/
>>
>>Would this be sufficient? Or should nr_disks be initialized as raid_disks
>>and then go into the switch clause?
>>    
>>
>
>I ended up just adding:
>
>	md.nr_disks = md.raid_disks;
>
>right be fore the switch statement and it worked fine in my situation.
>Not sure how this would work with other kernels etc. but I'll let you
>figure that out.  
>
>Thanks very much for your help.
>
>Steve
>
>  
>
Hi Steve,
             Technically speaking, you are doing the same thing. 
However, just write the function below to avoid any confusion.

int
md_get_subvol_stripe(
	char		*dfile,
	sv_type_t	type,
	int		*sunit,
	int		*swidth,
	int		*sectalign,
	struct stat64	*sb)
{
	if (mnt_is_md_subvol(sb->st_rdev)) {
		struct md_array_info	md;
		int			fd;

		/* Open device */
		fd = open(dfile, O_RDONLY);
		if (fd == -1)
			return 0;

		/* Is this thing on... */
		if (ioctl(fd, GET_ARRAY_INFO, &md)) {
			fprintf(stderr,
				_("Error getting MD array info from %s\n"),
				dfile);
			exit(1);
		}
		close(fd);

		/*
		 * Ignore levels we don't want aligned (e.g. linear)
		 * and deduct disk(s) from stripe width on RAID4/5/6
		 */
		switch (md.level) {
		case 6:
			md.raid_disks--;
			/* fallthrough */
		case 5:
		case 4:
			md.raid_disks--;
			/* fallthrough */
		case 1:
		case 0:
		case 10:
			break;
		default:
			return 0;
		}

		/* Update sizes */
		*sunit = md.chunk_size >> 9;
		*swidth = *sunit * md.raid_disks;
		*sectalign = (md.level == 4 || md.level == 5 || md.level == 6);

		return 1;
	}
	return 0;
}
