Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Nov 2007 17:17:58 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAQ1Hoxk026741
	for <xfs@oss.sgi.com>; Sun, 25 Nov 2007 17:17:53 -0800
Message-ID: <474A1F24.9070303@sgi.com>
Date: Mon, 26 Nov 2007 12:19:32 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] cleanup XFS_IFORK_*/XFS_DFORK* macros
References: <20070922102238.GA15732@lst.de> <20071125163102.GB17922@infradead.org>
In-Reply-To: <20071125163102.GB17922@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Sat, Sep 22, 2007 at 12:22:38PM +0200, Christoph Hellwig wrote:
>> (try number three, maybe it manages to get through the list this time)
>>
>> Currently XFS_IFORK_* and XFS_DFORK* are implemented by means of
>> XFS_CFORK* macros.  But given that XFS_IFORK_* operates on an
>> xfs_inode that embedds and xfs_icdinode_core and XFS_DFORK_* operates
>> on an xfs_dinode that embedds a xfs_dinode_core one will have to do
>> endian swapping while the other doesn't.  Instead of having the current
>> mess with the CFORK macros that have byteswapping and non-byteswapping
>> version (which are inconsistantly named while we're at it) just define
>> each family of the macros to stand by itself and simplify the whole
>> matter.
>>
>> A few direct references to the CFORK variants were cleaned up to
>> use IFORK or DFORK to make this possible.
> 
> ping?  this is almost two month old now..
> 

I'll have a look...

--Tim
