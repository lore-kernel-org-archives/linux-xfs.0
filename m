Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 15:22:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OMLsaG012448
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 15:21:55 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14611469A3C
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 15:18:09 -0700 (PDT)
Received: from agami.com ([192.168.168.147])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k9OMHp2J007607
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 15:17:51 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k9OMHjeR017237
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 15:17:45 -0700
Message-ID: <453E9067.1010107@agami.com>
Date: Tue, 24 Oct 2006 15:15:03 -0700
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: [REVIEW 1 of 4] Clean up i_flags handling
References: <20061024071723.GR11034@melbourne.sgi.com> <20061024213822.GA23909@infradead.org>
In-Reply-To: <20061024213822.GA23909@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, t-nagano@ah.jp.nec.com, xfs-dev@sgi.com

Christoph Hellwig wrote:
>> +/*
>> + * i_flags helper functions
>> + */
>> +static inline void
>> +__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
>> +{
>> +	ip->i_flags |= flags;
>> +}
>> +
>> +static inline void
>> +xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
>> +{
>> +	spin_lock(&ip->i_flags_lock);
>> +	__xfs_iflags_set(ip, flags);
>> +	spin_unlock(&ip->i_flags_lock);
>> +}
>>     
>
> This is not actually 
>
>   
>> +
>> +static inline void
>> +xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
>> +{
>> +	spin_lock(&ip->i_flags_lock);
>> +	ip->i_flags &= ~flags;
>> +	spin_unlock(&ip->i_flags_lock);
>> +}
>> +
>> +static inline int
>> +__xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
>> +{
>> +	return (ip->i_flags & flags);
>> +}
>> +
>> +static inline int
>> +xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
>> +{
>> +	int ret;
>> +	spin_lock(&ip->i_flags_lock);
>> +	ret = __xfs_iflags_test(ip, flags);
>> +	spin_unlock(&ip->i_flags_lock);
>> +	return ret;
>>     
>
> This is not actually guaranteed to work on machiens with very weak
> memory ordering.  Please use the *_bit routines from bitops.h instead.
>
>   
Isn't true that UNLOCK and LOCK in the given order imply full barrier 
Chris ?
As the flag is modified only within the lock/unlock pair, if one tries 
to access the field (test it), it should be like
LOCK IP
modify ...
UNLOCK IP  -----|
                           |  --->  This pair should act as a full 
barrier. 
LOCK IP       -----|
read ...           
UNLOCK IP

-shailendra
