Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 409987F72
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 10:18:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B900CAC002
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 08:18:52 -0700 (PDT)
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [195.71.86.230]) by
	cuda.sgi.com with ESMTP id A9U3E5F1LCvHZ4QP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Mar 2013 08:18:46 -0700 (PDT)
Date: Sun, 17 Mar 2013 16:18:41 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Xfs_repair and journalling
Message-ID: <20130317151841.GA9044@citd.de>
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<51455408.4070801@hardwarefreak.com>
	<CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
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
To: Subranshu Patel <spatel.ml@gmail.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On 17.03.2013 17:12, Subranshu Patel wrote:
> 
> In case of EXT4, journal will not be replayed on performing mount. One need
> to invoke fsck which performs journal playback and then other corruption
> checks/recovery.
> Correct me if I am wrong.

Wrong.

ALL Journaling FSes automatically replay the long upon mounting, or at 
least i don't know of any that don't.

Only if there is additional corruption the corresponding fsck comes into 
play.

For XFS i have only needed xfs_repair 1 time in over 10 years (and 
countless power-failures/spontanous resets, forgotten umounts 
(USB-drives) ...) and that was caused by a bug in XFS that was fixed 
recently, otherwise my stat would still be 0.

In most cases, after an unclean shutdown, the journal is replayed and 
everything is fine. Otherwise you either hit a bug (that needs fixing), 
or you have hardware problems.



-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
