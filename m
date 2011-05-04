Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44AWvsl070797 for <xfs@oss.sgi.com>; Wed, 4 May 2011 05:32:58 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 170CC11CBB82
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 03:36:34 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id IoU5paGEUwcsQQ4C
	for <xfs@oss.sgi.com>; Wed, 04 May 2011 03:36:34 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 485416C0F7
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 05:36:34 -0500 (CDT)
Message-ID: <4DC12C2F.8060800@hardwarefreak.com>
Date: Wed, 04 May 2011 05:36:31 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS/Linux Sanity check
References: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>	<20110503031856.GA9114@dastard>
	<BANLkTikNkErCS4q41ajTLa2yJnD8uehY-w@mail.gmail.com>
In-Reply-To: <BANLkTikNkErCS4q41ajTLa2yJnD8uehY-w@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 5/3/2011 11:05 AM, Paul Anderson wrote:

> I'm still perfectly willing to buy good HW RAID cards, don't get me
> wrong, but their main benefit to me will be the battery backed cache,
> not the performance.

Good RAID cards have many more advantages than battery cache and 
performance.  One is moving a RAID card and its attached arrays from a 
failed host to a new one.  In the case of the hardware RAID card usually 
all that is required is loading the HBA driver and mounting the 
filesystem.  Such a move of an mdraid array is usually, well, not nearly 
as straightforward, to put it kindly.

> Keep in mind that it is hard to balance a HW RAID card across multiple
> SAS expanders -you can certainly get a -16e card of some sort, but
> then it does ALL of the I/O to those 4 expanders ALL of the time.

I'm note sure I know exactly what you mean here Paul. You seem to be 
talking about RAID card <-> drive chassis cabling flexibility and 
symmetrical bandwidth.  The following two SAS expander/switch products 
are likely worth a quick read:

http://www.intel.com/Products/Server/RAID-controllers/re-res2sv240/RES2SV240-Overview.htm
http://www.lsi.com/channel/products/switch/sas6160/index.html

Using an LSI 9260-4i single 8087 port RAID card, the Intel expander, and 
some 8087/8088 panel converters, one could attach *5* x 24 drive LSI 
620J SAS JBOD chassis for a total of 120 drives with equal bandwidth 
to/from all drives, about 2GB/s total bandwidth, RAID ASIC limited.  Few 
would want to connect 120 drives to such a single port RAID controller, 
but this example demonstrates that symmetry can be achieved across a 
large number of cascaded SAS expander ASICs (6 total) with a lot of drives.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
