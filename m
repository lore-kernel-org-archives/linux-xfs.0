Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A26F17F3F
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 11:49:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 794748F8071
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 09:49:36 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id r6UjR4dEm7404O41
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 09:49:35 -0800 (PST)
Message-ID: <530E292D.2080709@hardwarefreak.com>
Date: Wed, 26 Feb 2014 11:49:33 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <52E91923.4070706@sandeen.net>
	<52EB3B96.7000103@hardwarefreak.com>	<1391202273-sup-9265@al.wesleyan.edu>	<52ED61C9.8060504@hardwarefreak.com>	<20140202212152.GP2212@dastard>	<1391443675-sup-1730@al.wesleyan.edu>	<20140203214128.GR13997@dastard>	<52F09E36.8050606@hardwarefreak.com>	<1392748390-sup-1943@al.wesleyan.edu>	<5303E7AC.50903@hardwarefreak.com>	<20140220183125.29149.64880@al.wesleyan.edu>	<5306C90B.1000904@hardwarefreak.com>	<20140221095742.0ca161b0@galadriel.home>	<530809A7.70900@hardwarefreak.com>	<1393347755-sup-205@al.wesleyan.edu>	<530CF84C.2080200@hardwarefreak.com>
	<1393423550-sup-1535@al.wesleyan.edu>
In-Reply-To: <1393423550-sup-1535@al.wesleyan.edu>
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

On 2/26/2014 8:19 AM, C. Morgan Hamill wrote:
> Excerpts from Stan Hoeppner's message of 2014-02-25 15:08:44 -0500:
>> Only enough to recommend you to replace it immediately with an LSI or
>> Adaptec.  Areca is an absolutely tiny Taiwanese company with inferior
>> product and, from what I gather, horrible support for North American
>> customers, and Linux customers in general.  The vast majority of their
>> customers seem to be SOHOs and individuals using the boards in MS
>> Windows servers, with very few running more than a handful of drives,
>> and few running lots of drives doing serious work.
> 
> Noted.
> 
>> If you run into any kind of performance issue with their board, and
>> explain to them your number of drives and arrays, OS platform and
>> workload, they'll be baffled like a 3rd grader and have no idea how to
>> respond.
> 
> For better or worse, this will be in line with the "support" I've
> experienced from the vast majority of vendors I've had to deal with.

Edu's often have tight(er) budgets so this often goes with the
territory, unfortunately.  On the bright side, one tends to learn quite
a bit about the hardware industry, the secret sauce that separates two
vendors using the same ASICs, where the value add comes from, etc.
This, out of necessity.

>> The Areca uses inferior older technology, has inferior performance,
>> limited firmware feature set which doesn't support spans
>> (concatenation), near non-existent US support especially for advanced
>> Linux workloads/users, only offers battery cache backup, and is all of ...
>>
>> $10 USD cheaper than the category equivalent yet vastly superior LSI.
> 
> Does seem to be the case.
> 
>> By some off chance you don't already know, LSI is the industry gold
>> standard RAID HBA.  They are the sole RAID HBA OEM board supplier to
>> Dell, IBM, Intel, Lenovo, Fujitsu/Siemens, etc, and their ASICs are used
>> by many others on their in house designs.  LSI's ASICs and firmware have
>> seen more Linux workloads of all shapes and sizes than all other
>> vendors' RAID HBAs combined.
> 
> I am aware; all our servers have LSI in them for boot arrays and
> whatnot.
> 
>> Given all of the above, and that there are at least 3 other LSI boards
>> of superior performance, in the same price range for the past year, why
>> did you go with Areca?
> 
> For better or worse, they're what we were able to get from our white box
> vendor.  It will, unfortunately, have to do for now.  I'll be sure to
> make a note for future expansion.

In that case, exercise it mercilessly with your workload to surface any
problems the firmware may have with the triple RAID6 setup.  Yank a
drive from each array while under full IO load, etc.  Even if Areca
can't provide answers or fixes to problems you uncover, if you can
identify problem spots before production, you can document these and
take steps to mitigate them.

> Until then, we'll just have to tread carefully.

>From what I understand their hardware QC is decent so board failure
shouldn't be an issue.  The issues usually deal with firmware
immaturity.  They're a tiny company with limited resources thus they
simply can't do much workload testing with multiple array
configurations.  Thus their customers running higher end workloads often
end up being guinea pigs and identifying firmware deficiencies for them,
and suffering performance chasms in the process.

LSI, Adaptec, etc do have firmware issues as well on occasion.  But
their test lab resources allow them to flesh most of these out before
the boards reach customers.

> Thanks again for all of your help.

You bet.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
