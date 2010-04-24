Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3O2iSka110185 for <xfs@oss.sgi.com>; Fri, 23 Apr 2010 21:44:28 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3217A1D45B11
	for <xfs@oss.sgi.com>; Fri, 23 Apr 2010 19:46:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qrqNrzKjqjxwBQOk for
	<xfs@oss.sgi.com>; Fri, 23 Apr 2010 19:46:29 -0700 (PDT)
Received: from int-mx03.intmail.prod.int.phx2.redhat.com
	(int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3O2kSQi009144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 23 Apr 2010 22:46:29 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o3O2kN1C027104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 23 Apr 2010 22:46:27 -0400
Message-ID: <4BD25B7F.8020509@redhat.com>
Date: Fri, 23 Apr 2010 21:46:23 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [Fwd: Benchmarking data from a raid machine 2.6.34-rc3]
Content-Type: multipart/mixed; boundary="------------000503090000000906090306"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------000503090000000906090306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

FYI...

I asked Keith if he could do xfs nobarrier runs as well.

If there are ext4 nobarrier runs "winning" it seems only fair.  :)

-Eric

--------------000503090000000906090306
Content-Type: message/rfc822;
 name="Benchmarking data from a raid machine 2.6.34-rc3.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="Benchmarking data from a raid machine 2.6.34-rc3.eml"

Return-Path: linux-ext4-owner@vger.kernel.org
Received: from zmta03.collab.prod.int.phx2.redhat.com (LHLO
 zmta03.collab.prod.int.phx2.redhat.com) (10.5.5.33) by
 mail06.corp.redhat.com with LMTP; Fri, 23 Apr 2010 20:06:40 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta03.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 0A5544CCAE;
	Fri, 23 Apr 2010 20:06:40 -0400 (EDT)
Received: from zmta03.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta03.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N0+a-T+k1WYR; Fri, 23 Apr 2010 20:06:39 -0400 (EDT)
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by zmta03.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id E184C4CB39;
	Fri, 23 Apr 2010 20:06:39 -0400 (EDT)
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com [10.5.110.6])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o3O06dAg012185;
	Fri, 23 Apr 2010 20:06:39 -0400
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3O06T8f005167;
	Fri, 23 Apr 2010 20:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0DXAGV (ORCPT <rfc822;lczerner@redhat.com> + 6 others);
	Fri, 23 Apr 2010 20:06:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50535 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab0DXAGU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Apr 2010 20:06:20 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e39.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o3NNvuoW025922
	for <linux-ext4@vger.kernel.org>; Fri, 23 Apr 2010 17:57:56 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o3O06JZC126758
	for <linux-ext4@vger.kernel.org>; Fri, 23 Apr 2010 18:06:19 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o3O06JPj024215
	for <linux-ext4@vger.kernel.org>; Fri, 23 Apr 2010 18:06:19 -0600
Received: from [9.76.76.183] (sig-9-76-76-183.mts.ibm.com [9.76.76.183])
	by d03av01.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVin) with ESMTP id o3O06ING024202
	for <linux-ext4@vger.kernel.org>; Fri, 23 Apr 2010 18:06:18 -0600
Subject: Benchmarking data from a raid machine 2.6.34-rc3
From: Keith Mannthey <kmannth@us.ibm.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 23 Apr 2010 17:06:18 -0700
Message-Id: <1272067578.9664.40.camel@keith-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
X-RedHat-Spam-Score: -2.31  (RCVD_IN_DNSWL_MED,T_RP_MATCHES_RCVD)
X-Scanned-By: MIMEDefang 2.67 on 10.5.11.18
X-Scanned-By: MIMEDefang 2.67 on 10.5.110.6

At long last here is a good data set for filesystem comparison.  It is
from 2.6.34-rc3 (unpatched). It compares ext3 ext4 ext4-nobarrier,
btrfs, btrfs-nocow, xfs and jfs on a software raid setup with a decent
spindle count. 

http://btrfs.boxacle.net/repository/raid/2010-04-14_2004/2.6.34-rc3/2.6.34-rc3.html


As we know touring barriers off helps a lot with ext4 on this machine.
I think Steve Pratt send some notification to the btrfs folks. Feel free
to point others at this data.


A history from this setup can be found here:  (mostly btrfs related
data)

http://btrfs.boxacle.net/repository/raid/history/History.html


I hope to be do these large data set runs once in every major kernel
revision life cycle. 

Thanks,
  Keith Mannthey
  LTC FS-Dev 


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--------------000503090000000906090306
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------000503090000000906090306--
