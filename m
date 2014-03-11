Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9F2E7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 23:56:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B22468F8037
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 21:56:41 -0700 (PDT)
Received: from bash.esri.com (Redlands.esri.com [198.102.62.250]) by
	cuda.sgi.com with ESMTP id G7xIhM5GEKFbjE42 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Mar 2014 21:56:40 -0700 (PDT)
Received: from bash.esri.com (localhost [127.0.0.1])
	by bash.esri.com (8.14.4/8.14.4) with ESMTP id s2B4udHC018269
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 21:56:39 -0700
Received: (from ray5147@localhost)
	by bash.esri.com (8.14.4/8.14.4/Submit) id s2B4udd5018267
	for xfs@oss.sgi.com; Mon, 10 Mar 2014 21:56:39 -0700
Date: Mon, 10 Mar 2014 21:56:39 -0700
From: Ray Van Dolson <rvandolson@esri.com>
Subject: sw and su for hardware RAID10 (w/ LVM)
Message-ID: <20140311045639.GA18159@esri.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

RHEL6.x + XFS that comes w/ Red Hat's scalable file system add on.  We
have two PowerVault MD3260e's each configured with a 30 disk RAID10 (15
RAID groups) exposed to our server.  Segment size is 128K (in Dell's
world I'm not sure if this means my stripe width is 128K*15?)

Have set up a concatenated LVM volume on top of these two "virtual
disks" (with lvcreate -i 2).

By default LVM says it's used a stripe width of 64K.

# lvs -o path,size,stripes,stripe_size
  Path                           LSize   #Str Stripe
  /dev/agsfac_vg00/lv00          100.00t    2 64.00k

Unsure if these defaults should be adjusted.

I'm trying to figure out the appropriate sw/su values to use per:

  http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance

Am considering either just going with defaults (XFS should pull from
LVM I think) or doing something like sw=2,su=128K.  However, maybe I
should be doing sw=2,su=1920K?  And perhaps my LVM stripe width should
be adjusted?

Thanks,
Ray

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
