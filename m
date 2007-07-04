Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jul 2007 22:37:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l645bStL032491
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2007 22:37:30 -0700
Message-ID: <468B31FD.2020703@sgi.com>
Date: Wed, 04 Jul 2007 15:37:01 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
References: <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070630165246.GA5159@schatzie.adilger.int> <20070703100848.GA14936@amitarora.in.ibm.com> <20070703103107.GA29763@infradead.org> <20070703114650.GB14936@amitarora.in.ibm.com>
In-Reply-To: <20070703114650.GB14936@amitarora.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, adilger@clusterfs.com, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

Amit K. Arora wrote:
>>>> FA_FL_NO_MTIME	0x10 /* keep same mtime (default change on size, data change) */
>>>> FA_FL_NO_CTIME	0x20 /* keep same ctime (default change on size, data change) */
>> NACK to these aswell.  If i_size changes c/mtime need updates, if the size
>> doesn't chamge they don't.  No need to add more flags for this.
> 
> This requirement was from the point of view of HSM applications. Hope
> you saw Andreas previous post and are keeping that in mind.
> 
We use this capability in XFS at the moment.
I think this is mainly for DMF (HSM) but is done via the xfs handle interface
(xfs_open_by_handle) AFAICT.

This sets up a set of invisible operations (xfs_invis_file_operations).
xfs_file_ioctl_invis goes on to set IO_INVIS which goes on to set ATTR_DMI
which is then tested in xfs_change_file_space() (which handles XFS_IOC_RESVSP & friends)
for whether xfs_ichgtime(ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG)
is called or not.

--Tim
