Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EAC947F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:08:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9DBDC8F804C
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:08:47 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 4dTMlhE3jEwHiH8w
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:08:46 -0800 (PST)
Message-ID: <530CF84C.2080200@hardwarefreak.com>
Date: Tue, 25 Feb 2014 14:08:44 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <52E91923.4070706@sandeen.net>
	<52EB3B96.7000103@hardwarefreak.com>	<1391202273-sup-9265@al.wesleyan.edu>	<52ED61C9.8060504@hardwarefreak.com>	<20140202212152.GP2212@dastard>	<1391443675-sup-1730@al.wesleyan.edu>	<20140203214128.GR13997@dastard>	<52F09E36.8050606@hardwarefreak.com>	<1392748390-sup-1943@al.wesleyan.edu>	<5303E7AC.50903@hardwarefreak.com>	<20140220183125.29149.64880@al.wesleyan.edu>	<5306C90B.1000904@hardwarefreak.com>	<20140221095742.0ca161b0@galadriel.home>	<530809A7.70900@hardwarefreak.com>
	<1393347755-sup-205@al.wesleyan.edu>
In-Reply-To: <1393347755-sup-205@al.wesleyan.edu>
Reply-To: stan@hardwarefreak.com
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
To: "C. Morgan Hamill" <chamill@wesleyan.edu>
Cc: xfs <xfs@oss.sgi.com>

On 2/25/2014 11:04 AM, C. Morgan Hamill wrote:
> Excerpts from Stan Hoeppner's message of 2014-02-21 21:21:27 -0500:
>> Now, it's possible he could do this entirely in the RAID firmware.
>> However he has not stated which storage product he has, and thus I don't
>> know its capabilities, whether it can create or seamlessly expand a
>> concatenation.  Linux md can do all of this very easily and is deployed
>> by many people in this exact scenario.
> 
> On this note, I'm using an Areca ARC-1882.  I've been looking for
> documentation regarding concatenation with this, and having a bit of
> trouble.
> 
> Do you happen to be familiar with the product?

Only enough to recommend you to replace it immediately with an LSI or
Adaptec.  Areca is an absolutely tiny Taiwanese company with inferior
product and, from what I gather, horrible support for North American
customers, and Linux customers in general.  The vast majority of their
customers seem to be SOHOs and individuals using the boards in MS
Windows servers, with very few running more than a handful of drives,
and few running lots of drives doing serious work.  If you run into any
kind of performance issue with their board, and explain to them your
number of drives and arrays, OS platform and workload, they'll be
baffled like a 3rd grader and have no idea how to respond.

The odd thing is that this isn't reflected in the price of their
products, which are not substantially less money than the best of breed
LSI boards, which come with LSI's phenomenal support structure.  And
there are plenty of LSI Linux customers running hundreds of drives with
real workloads.

Areca has no real presence North America, or any country for that
matter.  They're headquartered in Taiwan and have a "global office"
there.  Speaking of their "North American support", their ~1000 ft^2
office is in an industrial park in Walnut Grove, CA, directly across the
street from "Steve's Refrigeration Supply".  Check out the Google street
view for their office address, 150 Commerce Way, Walnut, CA 91789

Now let's have a look at LSI's North American presence.
http://www.lsi.com/northamerica/pages/northamerica.aspx#tab/tab-contactus

Now lets look at prices for the ARC-1882 and LSI's fastest 8P card.

Areca ARC-1882I
PCIe 2.0/3.0 x8, 1GB DDR3-1333, 800 MHz Dual Core RAID-on-Chip ASIC, 2x
SFF-8088 6G SAS, supports 128 drives
http://www.newegg.com/Product/Product.aspx?Item=N82E16816151105
$620

Battery Backed Write Cache module, 72hr max backup time, ARC-6120-T121
$130

Solution cost:  $750


LSI 9361-8i

PCIe 3.0 x8, 1GB DDR3-1866, 1.2GHz LSISAS3108 dual core RAID-On-Chip
ASIC, 2x SFF-8643 12G SAS, supports 128 drives
http://www.newegg.com/Product/Product.aspx?Item=N82E16816118230
$570

Flash Backed Write Cache module, LSICVM02, unlimited backup time
http://www.newegg.com/Product/Product.aspx?Item=N82E16816118232
$190

Solution cost:  $760


The Areca uses inferior older technology, has inferior performance,
limited firmware feature set which doesn't support spans
(concatenation), near non-existent US support especially for advanced
Linux workloads/users, only offers battery cache backup, and is all of ...

$10 USD cheaper than the category equivalent yet vastly superior LSI.

By some off chance you don't already know, LSI is the industry gold
standard RAID HBA.  They are the sole RAID HBA OEM board supplier to
Dell, IBM, Intel, Lenovo, Fujitsu/Siemens, etc, and their ASICs are used
by many others on their in house designs.  LSI's ASICs and firmware have
seen more Linux workloads of all shapes and sizes than all other
vendors' RAID HBAs combined.

Given all of the above, and that there are at least 3 other LSI boards
of superior performance, in the same price range for the past year, why
did you go with Areca?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
