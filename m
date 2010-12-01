Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB10k0pA156422 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 18:46:01 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13A681401EE9
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 16:47:41 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 5A024ECAmaTj1wDM
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 16:47:41 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 0FE216C0B4
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 18:47:40 -0600 (CST)
Message-ID: <4CF59B2B.80701@hardwarefreak.com>
Date: Tue, 30 Nov 2010 18:47:39 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: performance
References: <AANLkTi=u8dX0ehPN3Rv3FQ+84htY3AYEv0eboGgC7_qi@mail.gmail.com>	<20101129001112.GA28672@dastard>	<AANLkTikom6jpkuZquTfinGpaqz4Gp0y8niYN7yWQgmzj@mail.gmail.com>	<20101129015937.GB28672@dastard>	<AANLkTikw086Z_66cz_U-EdFQx14TXP6XmiG-KyLN4BLo@mail.gmail.com>	<AANLkTi=-y0v4MzyU+qWPmvazouDu0N3gqSvVTU1z4Gke@mail.gmail.com>	<4CF33D0F.6080404@hardwarefreak.com>	<20101130042913.GB3556@dastard>	<4CF48299.2030204@hardwarefreak.com>
	<20101130075109.GN13830@dastard>
In-Reply-To: <20101130075109.GN13830@dastard>
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
To: xfs@oss.sgi.com

Dave Chinner put forth on 11/30/2010 1:51 AM:

> No, it detected the RAID configuration. 16 AGs is the default for a
> RAID device, 4 AGs is used if RAID is not detected.

So, as a general rule of thumb, one should have as many AGs as the
maximum number of potential writers, assuming the underlying storage
device can handle the I/O?  For instance, on a quad socket 12 core Magny
Cours system with 48 total cores, if one has an application with 48
writing threads, one should have at least 48 AGs?

And if the the default is 4 AGs per physical disk, does this mean one
should have at least 12 drives in the stripe width?  I'm thinking of
SRDs in my example, not SSDs.  And obviously if these are heavy writing
threads, a single 2 GHz core can easily outrun a single disk, so one
would probably want at least 48 SRDs if not 96 in the stripe.  Yes?
Obviously there are potentially many other factors that may come into
play in this equation.  I'm just looking for a general formula one
should use as a baseline template, as 16 AGs doesn't seem to be enough
for any application, core/thread count, SRD RAID configuration.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
