Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8481F7F93
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 10:01:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 15DF9AC00E
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 08:01:44 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id j6iRghHvkn8yAjSm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Nov 2013 08:01:43 -0800 (PST)
Message-ID: <52864537.3040800@oracle.com>
Date: Sat, 16 Nov 2013 00:00:55 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/6] list: introduce list_last_entry_or_null()
References: <5285A33C.4040808@oracle.com>
	<20131115141100.GA17659@infradead.org>
In-Reply-To: <20131115141100.GA17659@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: jfs-discussion@lists.sourceforge.net, jiri@resnulli.us, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, oleg@redhat.com, akpm@linux-foundation.org


On 11/15 2013 22:11, Christoph Hellwig wrote:
> On Fri, Nov 15, 2013 at 12:29:48PM +0800, Jeff Liu wrote:
>> Hi Folks,
>>
>> This patch is trying to introduce a new list helper to retrieve the
>> last entry or return NULL if the list is empty corresponding to it,
>> which is inspired by Jiri Pirko's list_first_entry_or_null().
> 
> How did we end up with the stupid _or_null prefix there?  I think the
> functionality is useful, but the naming is way to verbose, especially
> given that a list_first_entry or list_last_entry that optimizes away
> that one check doesn't seem useful.
> Instead of encoding detailed semantics in the name a good kerneldoc
> comment is way better.
When it comes to this point, looks the name is really a bit verbose.
And yes, they have the same kernel doc to list_first_entry/list_last_entry.

But at rculist.h, we have another similar routine with this suffix, i.e,
list_fist_or_null_rcu().

Maybe we can figure out a better name and replace the existing code with it
as list_first_entry_or_null() has not yet been widely used, it mainly being
used in drivers code as per a grep against linux-next tree.
 
$ grep list_first_entry_or_null -r linux-next

./drivers/acpi/acpi_ipmi.c:		driver_data.selected_smi = list_first_entry_or_null(
./drivers/base/regmap/regmap.c:		async = list_first_entry_or_null(&map->async_free,
./drivers/base/regmap/regmap.c:		async = list_first_entry_or_null(&map->async_free,
./drivers/net/team/team.c:	port = list_first_entry_or_null(&team->port_list,
./drivers/net/ethernet/sfc/mcdi.c:		async = list_first_entry_or_null(
./drivers/net/ethernet/intel/i40e/i40e_main.c:	return list_first_entry_or_null(&vsi->mac_filter_list,
./drivers/net/vxlan.c:	rd = list_first_entry_or_null(&f->remotes, struct vxlan_rdst, list);
./drivers/of/irq.c:		desc = list_first_entry_or_null(&intc_parent_list,
./fs/xfs/xfs_trans_priv.h:	return list_first_entry_or_null(&ailp->xa_ail, struct xfs_log_item,
./net/nfc/digital_core.c:	cmd = list_first_entry_or_null(&ddev->cmd_queue, struct digital_cmd,
./net/nfc/digital_core.c:	cmd = list_first_entry_or_null(&ddev->cmd_queue, struct digital_cmd,


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
