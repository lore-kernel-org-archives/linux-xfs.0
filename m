Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C27CD7CA2
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 09:51:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1678304059
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 07:51:07 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 31woxhKFGgNF2PTt for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 07:51:04 -0800 (PST)
Subject: Re: [PATCH 2/2 v2] xfs_repair: new secondary superblock search
	method] xfs_repair: new secondary superblock search method
References: <1455068099-26992-1-git-send-email-billodo@redhat.com>
	<56BAC150.7070808@sandeen.net> <20160210154300.GA9472@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BB5C67.6040906@sandeen.net>
Date: Wed, 10 Feb 2016 09:51:03 -0600
MIME-Version: 1.0
In-Reply-To: <20160210154300.GA9472@redhat.com>
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
To: Bill O'Donnell <billodo@redhat.com>
Cc: xfs@oss.sgi.com

On 2/10/16 9:43 AM, Bill O'Donnell wrote:
>> I'd make __find_secondary_sb() take (sb, start, skip) i.e. send in
>> > this:
>> > 
>>> > > +	retval = __find_secondary_sb(rsb, agsize, agsize);
>>> > > +	if (!retval)  {
>>> > > +		/*
>>> > > +		 * fallback: use minimum agsize for skipsize
>>> > > +		 */
>>> > > +		retval = __find_secondary_sb(rsb, XFS_AG_MIN_BYTES, BSIZE);
>>> > > +	}
>> > 
>> > and the function is something like:
>> > 
>> > static int
>> > __find_secondary_sb(
>> >         xfs_sb_t	*rsb,
>> > 	xfs_off_t	start,
>> >         xfs_off_t	skip)
>> > 
>> > {
>> > 
>> > ...
>> > 
>> >         for (done = 0, off = start; !done ; off += skip)  {
>> > ...
>> >                if (lseek64(x.dfd, off, SEEK_SET) != off)
>> >                         done = 1;
>> > 
>> >                if (!done && (read(x.dfd, sb, BSIZE)) <= 0)
>> >                         done = 1;
> But, bsize is used here:
> ...
>      	    * check the buffer 512 bytes at a time since
> 	    * we don't know how big the sectors really are.
> 	    */
> 	    for (i = 0; !done && i < bsize; i += BBSIZE)  {
> ...
> so, don't we still need to populate bsize? Or does it make more
> sense to just use BBSIZE in the conditional, ala:
>             for (i = 0; !done && i < BBSIZE; i += BBSIZE) 

Oh, right, sorry.  yes, keep the assignment:

                if (!done && (bsize = read(x.dfd, sb, BSIZE)) <= 0)  {

That handles a short read at the end; we ask for BSIZE, actually
read bsize, and then we need to iterate over what actually got read
(bsize).

BSIZE, bsize ... clear as mud.  :(

-Eric

>> > 
>> > 
>> > because you really can't deduce both the starting point and the skip-ahead
>> > size from just one parameter.
> Agreed.
> Thanks for your thorough reviews :)
> Bill
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
