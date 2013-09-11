Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A96867F51
	for <linux-xfs@oss.sgi.com>; Tue, 10 Sep 2013 21:27:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B668AC006
	for <linux-xfs@oss.sgi.com>; Tue, 10 Sep 2013 19:27:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mUdeRIEcvDAzxgN4 for <linux-xfs@oss.sgi.com>;
	Tue, 10 Sep 2013 19:27:45 -0700 (PDT)
Message-ID: <522FD520.6090308@sandeen.net>
Date: Tue, 10 Sep 2013 21:27:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs_repair: test for bad level in dir2 node
References: <52274F96.2010702@sandeen.net> <522F4001.8010104@sandeen.net>
	<522F4C26.2080106@sgi.com> <522F55B9.3030509@sandeen.net>
	<522F5ED7.80005@sgi.com>
In-Reply-To: <522F5ED7.80005@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 9/10/13 1:03 PM, Mark Tinguely wrote:
>> 1) The block magic is LEAFN.  If so, we stop.  We warn if it's not root level (but don't fix?  Maybe that's a bug for another patch?)
> 
> Yes. We do not loop if "i == 1", so another LEAF should not be found.



>> 2) The block magic is NODE.  If not, we error out.
> 
> Yes.
> 
>> and as I showed above:
>> 3) The level matches each level we're at in the loop.
>>
>> So:
>>
>> Any block which isn't LEAFN or NODE is caught prior to the (i == -1) block.
> 
> Yes must be a NODE.
> 
>> Any block which has a level that doesn't match is caught on the else of the (i == -1) block.
> 
> Yes, and "i" has to be larger than 1 because of the loop. Which I did not catch before.
>>
>> And those are the only 2 valid types here.
>>
>> What case is missing?
>>
>> -eric
>>
> 
> With loop condition of "i > 1" then it cannot miss what I first thought was being missed, but the level of 1 being a leaf is not checked.

But I don't think that's right, is it?  level[0] is leaf; level[1] is a node, right?

Argh.  Now I'm more confused; xfs_check has:

        case XFS_DA_NODE_MAGIC:
                node = iocur_top->data;
                xfs_da3_node_hdr_from_disk(&nodehdr, node);
                if (nodehdr.level < 1 || nodehdr.level > XFS_DA_NODE_MAXDEPTH) {
                        if (!sflag || v)
                                dbprintf(_("bad node block level %d for dir ino "
                                         "%lld block %d\n"),
                                        nodehdr.level, id->ino,
                                        dabno);
                        error++;

so nodehdr.level == XFS_DA_NODE_MAXDEPTH is valid there (and level == 1 is a valid
node), but repair says:

                        if (i >= XFS_DA_NODE_MAXDEPTH) {
                                do_warn(
_("bad header depth for directory inode %" PRIu64 "\n"),
                                        da_cursor->ino);

so nodehdr.level == XFS_DA_NODE_MAXDEPTH is *not* valid here.

indices and counters and depths, oh my.  I need to back up and remember what's what.  :(

... Still not sure any of this invalidates my targeted fix - although I should just 
make it a one-liner and do:

                if (i == -1) {
                        i = da_cursor->active = nodehdr.level;
-                       if (i >= XFS_DA_NODE_MAXDEPTH) {
+                       if (i < 1 || i >= XFS_DA_NODE_MAXDEPTH) {
                                do_warn(
 _("bad header depth for directory inode %" PRIu64 "\n"),

-Eric

> --Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
