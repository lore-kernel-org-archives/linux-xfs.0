Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C5CC7F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 21:30:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27AFCAC001
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 19:30:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qITefTEqHoETJhvs for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 19:30:16 -0700 (PDT)
Message-ID: <550CD7B5.8030507@sandeen.net>
Date: Fri, 20 Mar 2015 21:30:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 03/13] xfs_db: add crc manipulation commands
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>	<1426624395-8258-4-git-send-email-sandeen@redhat.com>
	<20150319150755.GC11669@laptop.bfoster>
In-Reply-To: <20150319150755.GC11669@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On 3/19/15 10:07 AM, Brian Foster wrote:
> On Tue, Mar 17, 2015 at 03:33:05PM -0500, Eric Sandeen wrote:
>> This adds a new "crc" command to xfs_db for CRC-enabled filesystems.
...

if (argc) while ((c = getopt(argc, argv, "irv")) != EOF) {
> 
> The 'if (argc)' thing strikes again. Does this address something I'm not
> aware of?

just a dumb/unfortunate cut & paste from elsewhere, I'll fix.

...

>> +		/* Off by one.. */
>> +		crc = cpu_to_be32(crc + 1);
>> +		setbitval(iocur_top->data, sfl->offset, bit_length, &crc);
> 
> Some comments on the above code would be nice to explain what it's
> calculating.

Yeah, wish I'd written them "yonks ago" ;)  I'll reverse engineer my
patch & add comments.
 
>> +		dbprintf(_("Verifying CRC:\n"));
> 
> Does the "verify" aspect of this command do anything, or are we just
> printing the state that was determined from a previous cursor load? If
> the latter, I wonder if it's worth retaining that option (e.g., just
> print an inode to see the crc state)..?

If having a specific CRC handler makes sense (and, maybe it doesn't,
with the other patch that allows corrupted write), the symmetry seemed
nice.

Given the amount of code this adds, perhaps we should just drop it,
TBH, and use the "write -c" functionality I added, instead.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
